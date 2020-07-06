//
//  LoginScreenViewController.swift
//  Course4FinalTask
//
//  Created by Aleksey Bardin on 27.06.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class LoginScreenViewController: UIViewController {

  @IBOutlet private var login: UITextField!
  @IBOutlet private var password: UITextField!
  @IBOutlet private var signInButton: UIButton!

  lazy var rootViewController = AppDelegate.shared.rootViewController
  private let sessionProvider = SessionProvider()
  private var keychain = Keychain.shared

  override func viewDidLoad() {
    super.viewDidLoad()
    signInButton.layer.cornerRadius = cornerRadiusButton
    disableSignInButton()
    setDelegate()
  }

  @IBAction func sendAuthorizationRequest(_ sender: Any) {
    guard let login = login.text, let password = password.text else { return }
    sessionProvider.signin(login: login, password: password) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let token):
          self.keychain.saveToken(token.token)
          print(token)
          DispatchQueue.main.async {
            self.rootViewController.switchToFeedViewController()
          }
        case .fail(let backendError):
          DispatchQueue.main.async {
            print(backendError)
            Alert.showAlert(self, backendError.errorMassege)
//            self.displayAlert()
          }

      }
    }

  }

  @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
    login.resignFirstResponder()
    password.resignFirstResponder()
  }

}

// MARK: LoginScreenViewController + Helper
private extension LoginScreenViewController {
  func disableSignInButton() {
    signInButton.isEnabled = false
    signInButton.alpha = 0.3
  }

  func enableSignInButton() {
    signInButton.isEnabled = true
    signInButton.alpha = 1
  }
}

// MARK: TextFieldDelegate
extension LoginScreenViewController: UITextFieldDelegate {
  func setDelegate() {
    login.delegate = self
    password.delegate = self
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard
      let login = login.text,
      let password = password.text,
      !login.isEmpty && !password.isEmpty else {
        displayAlert()
        return false
    }

    rootViewController.switchToFeedViewController()
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard
      let login = login.text,
      let password = password.text,
      !login.isEmpty && !password.isEmpty else {
        disableSignInButton()
        return
    }

    enableSignInButton()
  }
}
