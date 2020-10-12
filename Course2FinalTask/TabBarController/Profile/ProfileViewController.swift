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
    private let onlineService = CheckOnlineService.shared
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

        setupUser()
    }
}

// MARK: DataSource
extension ProfileViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onlineService.isOnline ? postsProfile.count : offlinePostsProfile.count
    }

    /// установка изображений
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: ProfileCollectionViewCell.self, for: indexPath)

        if onlineService.isOnline {
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

        if onlineService.isOnline {
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

    func setupUser() {
        guard let userID = feedUserID else {
            loadCurrentUser()
            return
        }
        loadUserByProfile(userID)
        setupBackButton()
    }

    func updateUI() {
        DispatchQueue.main.async {
            ActivityIndicator.stop()
            self.view.backgroundColor = SystemColors.backgroundColor
            self.title = self.userProfile?.username
            self.tabBarItem.title = Localization.Controller.profile
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
        guard onlineService.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard let token = keychain.readToken() else { return }
        networkService.authorization().signOut(token) { _ in }
        keychain.deleteToken()
        rootViewController.switchToLogout()
    }

    /// Загрузка профиля друга из ленты
    func loadUserByProfile(_ userID: String) {
        guard onlineService.isOnline else {
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
        guard onlineService.isOnline else {
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

                    // Сохраняются данные текущего пользователя в coredata
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
        guard onlineService.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard let token = keychain.readToken() else { return }

        let userListViewController = UserListViewController()
        guard let userID = userProfile?.id else { return }

        networkService.getRequest().getFollowersWithUserID(token, userID) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        userListViewController.usersList = users
                        userListViewController.navigationItemTitle = Localization.Names.followers
                        self.navigationController?.pushViewController(userListViewController, animated: true)
                    }
                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }
        }
    }

    /// Открывает список подписок
    func openFollowingList() {
        guard onlineService.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard let token = keychain.readToken() else { return }

        let userListViewController = UserListViewController()

        guard let userID = userProfile?.id else { return }

        networkService.getRequest().getFollowingWithUserID(token, userID) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        userListViewController.usersList = users
                        userListViewController.navigationItemTitle = Localization.Names.following
                        self.navigationController?.pushViewController(userListViewController, animated: true)
                    }
                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }
        }
    }

    /// Подписывает и отписывает текущего пользователя от друзей
    func followUnfollowUser() {
        guard onlineService.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard
            let token = keychain.readToken(),
            let userProfile = userProfile
        else {
            return
        }

        guard userProfile.currentUserFollowsThisUser else {
            followCurrentUserWithUserID(token, userProfile.id)
            return
        }

        unfollowCurrentUserWithUserID(token, userProfile.id)
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

    func followCurrentUserWithUserID(_ token: String, _ userID: String) {
        networkService.postRequest().followCurrentUserWithUserID(token, userID) { [weak self] result in
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
    }

    func unfollowCurrentUserWithUserID(_ token: String, _ userID: String) {
        networkService.postRequest().unfollowCurrentUserWithUserID(token, userID) { [weak self] result in
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

    func checkOnlineSession() -> Bool {
        guard onlineService.isOnline else {

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
                self.tabBarItem.title = Localization.Controller.profile
                self.setLogout()
            }

            return false
        }
        return true
    }
}
