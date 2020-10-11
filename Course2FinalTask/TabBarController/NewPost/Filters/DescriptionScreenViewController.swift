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
    @IBOutlet private var descriptionLabel: UILabel!

    public var newPublishedPhoto: UIImage?
    private var networkService = NetworkService()
    private let onlineService = CheckOnlineService.shared
    private var keychain = Keychain.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SystemColors.backgroundColor
        setupFiltersViewController()
        setupBackButton()
        setDelegate()
    }
}

private extension DescriptionScreenViewController {

    func setupFiltersViewController() {
        publishedPhoto.image = newPublishedPhoto
        descriptionLabel.text = Localization.Names.description

        descriptionText.placeholder = Localization.Placeholder.description
        let shared = UIBarButtonItem(image: Buttons.sharedPost,
                                     style: .done,
                                     target: self,
                                     action: #selector(self.sharedPhoto(_:)))
        shared.tintColor = Asset.ColorAssets.buttonBackground.color
        self.navigationItem.rightBarButtonItem = .some(shared)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.setRightBarButton(shared, animated: true)
    }

    @objc
    func sharedPhoto(_ sender: UITapGestureRecognizer) {
        sendPost()
    }

    func sendPost() {
        guard onlineService.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        ActivityIndicator.start()
        guard let navigationController = tabBarController?.viewControllers?[0] as? UINavigationController else { return }
        guard let feedViewController = navigationController.viewControllers.first as? FeedViewController else { return }

        guard
            let newPublishedPhoto = newPublishedPhoto,
            let descriptionText = descriptionText.text,
            let feedPost = feedViewController.newPost,
            let token = keychain.readToken() else { return }

        networkService.postRequest().createPost(token, newPublishedPhoto, descriptionText) { [weak self] result in
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
                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }
        }
    }
}

extension DescriptionScreenViewController: UITextFieldDelegate {
    func setDelegate() {
        descriptionText.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendPost()
        return true
    }
}
