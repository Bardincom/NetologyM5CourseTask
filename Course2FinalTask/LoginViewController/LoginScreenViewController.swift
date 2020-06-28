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

  override func viewDidLoad() {
    super.viewDidLoad()
    signInButton.layer.cornerRadius = 5
    disableSignInButton()
    setDelegate()
  }

  @IBAction func sendAuthorizationRequest(_ sender: Any) {
    AppDelegate.shared.rootViewController.switchToFeedViewController()
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
    textField.resignFirstResponder()
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let simbolCount = login.text?.count else { return }

    if simbolCount > 0 {
      enableSignInButton()
    } else {
      disableSignInButton()
    }
  }
}
