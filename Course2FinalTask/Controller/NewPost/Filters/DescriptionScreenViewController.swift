//
//  DescriptionScreenViewController.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 13.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit
import DataProvider

class DescriptionScreenViewController: UIViewController {

    @IBOutlet private var publishedPhoto: UIImageView!
    @IBOutlet private var descriptionText: UITextField!

    public var newPublishedPhoto: UIImage?

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
            let feedPost = feedViewController.newPost else { return }

        postsDataProviders.newPost(with: newPublishedPhoto, description: descriptionText, queue: queue) { newPost in
            guard let newPost = newPost else {
                self.displayAlert()
                return }

            DispatchQueue.main.async {
                feedPost(newPost)

                // переключает tabBar на первую вкладку для отображения экрана feed
                self.tabBarController?.selectedViewController = navigationController
                // сбрасывает стэк текущего navigationController до корневого контроллера
                self.navigationController?.popToRootViewController(animated: true)

                ActivityIndicator.stop()

            }
        }
    }
}
