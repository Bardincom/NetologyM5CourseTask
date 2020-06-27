//
//  AppDelegate.swift
//  Course2FinalTask
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        assembly()

        return true
    }
}

private extension AppDelegate {

    func assembly() {
        window = UIWindow(frame: UIScreen.main.bounds)

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

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
