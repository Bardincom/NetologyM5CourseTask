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
    private let networkService = NetworkService()
    private let onlineService = CheckOnlineService.shared
    private var keychain = Keychain.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        disableSignInButton()
        setDelegate()
    }

    @IBAction func sendAuthorizationRequest(_ sender: Any) {
        authorization()
    }

    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        login.resignFirstResponder()
        password.resignFirstResponder()
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
            !login.isEmpty && !password.isEmpty
        else {
            return false
        }

        authorization()

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard
            let login = login.text,
            let password = password.text,
            !login.isEmpty && !password.isEmpty
        else {
            disableSignInButton()
            return
        }

        enableSignInButton()
    }
}

// MARK: LoginScreenViewController + Helper
private extension LoginScreenViewController {
    func customizeUI() {
        signInButton.setTitle(Localization.Button.signIn, for: .normal)
        signInButton.layer.cornerRadius = Constants.cornerRadiusButton
        login.placeholder = Localization.Placeholder.login
        password.placeholder = Localization.Placeholder.password
    }

    func disableSignInButton() {
        signInButton.isEnabled = false
        signInButton.alpha = 0.3
    }

    func enableSignInButton() {
        signInButton.isEnabled = true
        signInButton.alpha = 1
    }

    func authorization() {
        guard onlineService.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard
            let login = login.text,
            let password = password.text
        else {
            return
        }

        networkService.authorization().signIn(login: login, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let token):
                        self.keychain.saveToken(token.token)
                        self.rootViewController.switchToFeedViewController()
                    case .failure(let backendError):
                        Alert.showAlert(self, backendError.description)
                }
            }
        }
    }
}
