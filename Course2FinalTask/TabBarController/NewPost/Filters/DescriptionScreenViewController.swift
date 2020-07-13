//
//  DescriptionScreenViewController.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 13.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class DescriptionScreenViewController: UIViewController {

  @IBOutlet private var publishedPhoto: UIImageView!
  @IBOutlet private var descriptionText: UITextField!

  public var newPublishedPhoto: UIImage?
  private var session = SessionProvider.shared
  private var keychain = Keychain.shared

  override func viewDidLoad() {
    super.viewDidLoad()

    setupFiltersViewController()
  }
}

extension DescriptionScreenViewController {

  func setupFiltersViewController() {
    publishedPhoto.image = newPublishedPhoto

    descriptionText.placeholder = "Enter you description"
    navigationItem.rightBarButtonItem = .init(title: "Shared", style: .plain, target: self, action: #selector(sharedPhoto(_:)))
  }

  @objc
  func sharedPhoto(_ sender: UITapGestureRecognizer) {
    ActivityIndicator.start()
    guard let navigationController = tabBarController?.viewControllers?[0] as? UINavigationController else { return }
    guard let feedViewController = navigationController.viewControllers.first as? FeedViewController else { return }

    guard
      let newPublishedPhoto = newPublishedPhoto,
      let descriptionText = descriptionText.text,
      let feedPost = feedViewController.newPost,
      let token = keychain.readToken() else { return }

    session.createPost(token, newPublishedPhoto, descriptionText) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let newPost):
          DispatchQueue.main.async {
            feedPost(newPost)

            // переключает tabBar на первую вкладку для отображения экрана feed
            self.tabBarController?.selectedViewController = navigationController
            // сбрасывает стэк текущего navigationController до корневого контроллера
            self.navigationController?.popToRootViewController(animated: true)

            ActivityIndicator.stop()
          }
        case .fail(let error):
          Alert.showAlert(self, error.description)
      }
    }
  }
}
