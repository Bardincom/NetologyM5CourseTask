//
//  RootViewController.swift
//  Course4FinalTask
//
//  Created by Aleksey Bardin on 28.06.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

  private var current: UIViewController
  private var keychain = Keychain.shared

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
    feedViewController.tabBarItem.image = Asset.IconAssets.feed.image
    let feedNavigationController = UINavigationController(rootViewController: feedViewController)

    let profileViewController = ProfileViewController()
    profileViewController.tabBarItem.title = ControllerSet.profileViewController
    profileViewController.tabBarItem.image = Asset.IconAssets.profile.image
    let profileNavigationController = UINavigationController(rootViewController: profileViewController)

    let newPostViewController = NewPostViewController()
    newPostViewController.tabBarItem.title = ControllerSet.newPostViewController
    newPostViewController.tabBarItem.image = Asset.IconAssets.plus.image
    let newNavigationController = UINavigationController(rootViewController: newPostViewController)

    let tabBarController = UITabBarController()
    tabBarController.tabBar.backgroundColor = Asset.ColorAssets.viewBackground.color
    tabBarController.setViewControllers([feedNavigationController, newNavigationController, profileNavigationController], animated: false)

    return tabBarController
  }

  func startController() {
    guard keychain.readToken() != nil else {
      addChild(current)
      current.view.frame = view.bounds
      view.addSubview(current.view)
      current.didMove(toParent: self)
      return }

    switchToFeedViewController()
  }
}
