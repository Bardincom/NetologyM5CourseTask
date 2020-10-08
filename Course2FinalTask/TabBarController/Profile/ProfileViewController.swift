//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 24.02.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {

    @IBOutlet weak private var profileCollectionView: UICollectionView! {
        willSet {
            newValue.register(nibCell: ProfileCollectionViewCell.self)
            newValue.register(nibSupplementaryView: ProfileHeaderCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
        }
    }

    var userProfile: User?
    var feedUserID: String?
    var currentUser: User?
    private let keychain = Keychain.shared
    private let networkService = NetworkService()
    private let onlineServise = CheckOnlineServise.shared
    private var postsProfile = [Post]()
    lazy var rootViewController = AppDelegate.shared.rootViewController
    private var coreDataService = CoreDataService()
    private var offlineCurrentUser: UserOffline?
    private var offlinePostsProfile = [PostOffline]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self
        tabBarController?.delegate = self

        configureTitle()
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard checkOnlineSession() else { return }

        if let userID = feedUserID {
            loadUserByProfile(userID)
            setupBackButton()
        } else {
            loadCurrentUser()
        }
    }
}

// MARK: DataSourse
extension ProfileViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onlineServise.isOnline ? postsProfile.count : offlinePostsProfile.count
    }

    /// установка изображений
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: ProfileCollectionViewCell.self, for: indexPath)

        if onlineServise.isOnline {
            let post = postsProfile.sorted { $0.createdTime > $1.createdTime }[indexPath.row]
            cell.setImageCell(post: post)
        } else {
            let post = offlinePostsProfile[indexPath.row]
            cell.setImageCell(postOffline: post)
        }

        return cell
    }

    /// устновка Хедера
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let view = collectionView.dequeue(supplementaryView: ProfileHeaderCollectionReusableView.self,
                                          kind: kind,
                                          for: indexPath)

        if onlineServise.isOnline {
            guard let userProfile = userProfile else { return view }
            view.setHeader(user: userProfile)
        } else {
            guard let userProfile = offlineCurrentUser else { return view }
            view.setHeader(userOffline: userProfile)
        }

        view.delegate = self

        return view
    }

    /// задаю размеры Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 86)
    }
}

// MARK: Delegate FlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 1 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (profileCollectionView.bounds.width - 1) / 3
        return CGSize(width: size, height: size)
    }
}

// MARK: setViewController
extension ProfileViewController {

    func updateUI() {
        DispatchQueue.main.async {
            ActivityIndicator.stop()
            self.view.backgroundColor = SystemColors.backgroundColor
            self.title = self.userProfile?.username
            self.tabBarItem.title = ControllerSet.profileViewController
            self.profileCollectionView.reloadData()
        }
    }

    func setLogout() {
        DispatchQueue.main.async {
            let logoutButton = UIBarButtonItem(image: Buttons.exit, style: .done, target: self, action: #selector(self.logout))
            logoutButton.tintColor = SystemColors.redColor
            self.navigationItem.rightBarButtonItem = .some(logoutButton)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationItem.setRightBarButton(logoutButton, animated: true)
        }
    }

    @objc
    private func logout() {
        guard onlineServise.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard let token = keychain.readToken() else { return }
        networkService.authorization().signout(token) { _ in }
        keychain.deleteToken()
        rootViewController.switchToLogout()
    }

    /// Загрузка профиля друга из ленты
    func loadUserByProfile(_ userID: String) {
        guard onlineServise.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard let token = keychain.readToken() else { return }
        ActivityIndicator.start()

        feedUserID = userID

        networkService.getRequest().getUserWithID(token, userID) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let user):
                    self.userProfile = user

                    self.networkService.getRequest().getPostsWithUserID(token, user.id) { [weak self] result in
                        guard let self = self else { return }

                        switch result {
                            case .success(let posts):
                                self.postsProfile = posts
                                self.updateUI()
                            case .failure(let error):
                                Alert.showAlert(self, error.description)
                        }
                    }

                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }
        }
    }

    /// Загрузка профиля текущего пользователя
    func loadCurrentUser() {
        guard onlineServise.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }
        setLogout()

        guard let token = keychain.readToken() else { return }

        ActivityIndicator.start()

        networkService.getRequest().getCurrentUser(token) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let currentUser):
                    self.userProfile = currentUser

                    // Сохраняются данные текущего пользователя в core data
                    self.coreDataService.saveOfflineUser().saveCurrentUserOffline(user: currentUser)

                    self.networkService.getRequest().getPostsWithUserID(token, currentUser.id) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                            case .success(let posts):
                                self.postsProfile = posts

                                self.updateUI()
                            case .failure(let error):
                                Alert.showAlert(self, error.description)
                        }
                    }
                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }
        }
    }
}

// MARK: ProfileHeaderDelegate
extension ProfileViewController: ProfileHeaderDelegate {
    /// Открывает список подписчиков
    func openFollowersList() {
        guard onlineServise.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard let token = keychain.readToken() else { return }
        ActivityIndicator.start()

        let userListViewController = UserListViewController()
        guard let userID = userProfile?.id else { return }

        networkService.getRequest().getFollowersWithUserID(token, userID) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        userListViewController.usersList = users

                        userListViewController.navigationItemTitle = Names.followers
                        self.navigationController?.pushViewController(userListViewController, animated: true)
                        ActivityIndicator.stop()
                    }
                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }
        }
    }

    /// Открывает список подписок
    func openFollowingList() {
        guard onlineServise.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard let token = keychain.readToken() else { return }
        ActivityIndicator.start()

        let userListViewController = UserListViewController()

        guard let userID = userProfile?.id else { return }

        networkService.getRequest().getFollowingWithUserID(token, userID) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        userListViewController.usersList = users
                        userListViewController.navigationItemTitle = Names.following
                        self.navigationController?.pushViewController(userListViewController, animated: true)
                        ActivityIndicator.stop()
                    }
                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }
        }
    }

    /// Подписывает и отписывает текущего пользователя от друзей
    func followUnfollowUser() {
        guard onlineServise.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard
            let token = keychain.readToken(),
            let userProfile = userProfile else { return }

        guard userProfile.currentUserFollowsThisUser else {
            networkService.postRequest().followCurrentUserWithUserID(token, userProfile.id) { [weak self] result in
                guard let self = self else { return }

                switch result {
                    case .success(let user):
                        self.userProfile = user
                        DispatchQueue.main.async {
                            self.currentUser?.followedByCount += 1
                            self.profileCollectionView.reloadData()
                        }
                    case .failure(let error):
                        Alert.showAlert(self, error.description)
                }
            }
            return
        }

        networkService.postRequest().unfollowCurrentUserWithUserID(token, userProfile.id) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let user):
                    self.userProfile = user
                    DispatchQueue.main.async {
                        self.currentUser?.followsCount -= 1
                        self.profileCollectionView.reloadData()
                    }
                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController === ProfileViewController.self {
            updateUI()
        }
    }
}

extension ProfileViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController !== navigationController {
            feedUserID = nil
            navigationController?.popToRootViewController(animated: false)
        }
    }
}

extension ProfileViewController {
    func checkOnlineSession() -> Bool {
        guard onlineServise.isOnline else {

            coreDataService.fetchData(for: UserOffline.self) { [weak self] userOffline in
                self?.offlineCurrentUser = userOffline.first
            }

            coreDataService.fetchData(for: PostOffline.self) { [weak self] postOffline in
                self?.offlinePostsProfile = postOffline.filter({ post -> Bool in
                    post.author == self?.offlineCurrentUser?.id
                })
            }

            DispatchQueue.main.async {
                self.title = self.offlineCurrentUser?.username
                self.tabBarItem.title = ControllerSet.profileViewController
                self.setLogout()
            }

            return false
        }
        return true
    }
}
