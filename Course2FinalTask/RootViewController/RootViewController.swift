//
//  RootViewController.swift
//  Course4FinalTask
//
//  Created by Aleksey Bardin on 28.06.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {

    private var current: UIViewController
    private var keychain = Keychain.shared
    private var networkService = NetworkService()
    private let onlineServise = CheckOnlineServise.shared

    init() {
        current = LoginScreenViewController()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        startController()
    }

    func switchToFeedViewController() {
        let feedScreen = assemblyTabBarController()
        addChild(feedScreen)
        feedScreen.view.frame = view.bounds
        view.addSubview(feedScreen.view)
        feedScreen.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = feedScreen
    }

    func switchToLogout() {
        let loginViewController = LoginScreenViewController()
        addChild(loginViewController)
        loginViewController.view.frame = view.bounds
        view.addSubview(loginViewController.view)
        loginViewController.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = loginViewController
    }
}

private extension RootViewController {
    func assemblyTabBarController() -> UITabBarController {
        let feedViewController = FeedViewController()
//        feedViewController.tabBarItem.title = ControllerSet.feedViewController
        feedViewController.tabBarItem.title = Localization.Controller.feed
        feedViewController.tabBarItem.image = Buttons.feed
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)

        let profileViewController = ProfileViewController()
//        profileViewController.tabBarItem.title = ControllerSet.profileViewController
        profileViewController.tabBarItem.title = Localization.Controller.profile
        profileViewController.tabBarItem.image = Buttons.profile
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)

        let newPostViewController = NewPostViewController()
//        newPostViewController.tabBarItem.title = ControllerSet.newPostViewController
        newPostViewController.tabBarItem.title = Localization.Controller.addPost
        newPostViewController.tabBarItem.image = Buttons.newPost
        let newNavigationController = UINavigationController(rootViewController: newPostViewController)

        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = Asset.ColorAssets.appearance.color
        tabBarController.setViewControllers([feedNavigationController, newNavigationController, profileNavigationController], animated: false)

        return tabBarController
    }

    func startController() {
        guard let token = keychain.readToken() else {
            // если никакого токена нет
            addChild(current)
            current.view.frame = view.bounds
            view.addSubview(current.view)
            current.didMove(toParent: self)
            return }
        // если токен есть проверяем действителен ли он
        networkService.checkToken().checkToken(token) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(_):
                        self.switchToFeedViewController()
                        return
                    case .failure(let backendError):
                        guard backendError != .transferError else {
                            print("Сеть не доступна: \(self.onlineServise.isOnline)")
                            self.switchToFeedViewController()
                            return
                        }
                        self.addChild(self.current)
                        self.current.view.frame = self.view.bounds
                        self.view.addSubview(self.current.view)
                        self.current.didMove(toParent: self)
                        return

                }
            }
        }
    }
}
