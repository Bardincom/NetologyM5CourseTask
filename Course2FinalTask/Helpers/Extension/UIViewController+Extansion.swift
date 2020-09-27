//
//  UIViewController+Extansion.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 27.09.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

extension UIViewController {
  func configureTitle() {
    let attributes = [NSAttributedString.Key.foregroundColor: Asset.ColorAssets.appearance.color, NSAttributedString.Key.font: Fonts.titleFont]
    self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key: Any]
  }
}

extension UIViewController {
  func setupBackButton() {
    let backButton = UIBarButtonItem(image: Buttons.back,
                                     style: .plain,
                                     target: self,
                                     action: #selector(goToMainViewController))
    backButton.tintColor = Asset.ColorAssets.appearance.color
    navigationItem.leftBarButtonItem = .some(backButton)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
  }

  @objc
  func goToMainViewController() {
    navigationController?.popViewController(animated: true)
  }
}
