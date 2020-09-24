//
//  AppDelegate.swift
//  Course2FinalTask
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    _ = CoreDataManager.shared

    assembly()

    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
      CoreDataManager.shared.save()
  }
}

private extension AppDelegate {

  func assembly() {
    window = UIWindow(frame: UIScreen.main.bounds)

    let rootViewController = RootViewController()
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
  }
}

// swiftlint:disable force_cast
// swiftlint:disable force_unwrapping
extension AppDelegate {
  static var shared: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  var rootViewController: RootViewController {
    return window!.rootViewController as! RootViewController
  }
}
