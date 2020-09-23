//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 24.02.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {

  var userProfile: User?
  var feedUserID: String?
  var currentUser: User?
  private let keychain = Keychain.shared
  private let session = SessionProvider.shared
  private var postsProfile = [Post]()
  lazy var rootViewController = AppDelegate.shared.rootViewController

  lazy var coreDataManager = CoreDataManager.shared
  private var offlineCurrentUser: UserOffline?
  private var offlinePostsProfile = [PostOffline]()

  @IBOutlet weak private var profileCollectionView: UICollectionView! {
    willSet {
      newValue.register(nibCell: ProfileCollectionViewCell.self)
      newValue.register(nibSupplementaryView: ProfileHeaderCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Asset.ColorAssets.viewBackground.color

    navigationController?.delegate = self
    tabBarController?.delegate = self

    view.backgroundColor = Asset.ColorAssets.viewBackground.color

    updateUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard session.isOnline else {
      offlineCurrentUser = coreDataManager.fetchData1(for: UserOffline.self).first
      offlinePostsProfile = coreDataManager.fetchData(for: PostOffline.self).filter({ (postOffline) -> Bool in
        postOffline.author == offlineCurrentUser?.id
      })
      DispatchQueue.main.async {
        self.title = self.offlineCurrentUser?.username
        self.tabBarItem.title = ControllerSet.profileViewController
        self.setLogout()
      }

      return
    }

    if let userID = feedUserID {
      loadUserByProfile(userID)
    } else {
      loadCurrentUser()
    }
  }

}

// MARK: DataSourse
extension ProfileViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    guard let postsProfile = postsProfile else { return [Post]().count }
    return session.isOnline ? postsProfile.count : offlinePostsProfile.count
  }

  /// установка изображений
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(cell: ProfileCollectionViewCell.self, for: indexPath)

//    guard let postsProfile = postsProfile else { return cell }
    if session.isOnline {
      let post = postsProfile[indexPath.row]
      cell.setImageCell(post: post)
    } else {
      let post = offlinePostsProfile[indexPath.row]
      cell.setImmCell(postOffline: post)
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

    if session.isOnline {
      guard let userProfile = userProfile else { return view }
      view.setHeader(user: userProfile)
    } else {
      guard let userProfile = offlineCurrentUser else { return view }
      view.setHeader(user: userProfile)
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

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = profileCollectionView.bounds.width / 3
    return CGSize(width: size, height: size)
  }

}

// MARK: setViewController
extension ProfileViewController {

  func updateUI() {
    DispatchQueue.main.async {
      ActivityIndicator.stop()
      self.view.backgroundColor = Asset.ColorAssets.viewBackground.color
      self.title = self.userProfile?.username
      self.tabBarItem.title = ControllerSet.profileViewController
      self.profileCollectionView.reloadData()
    }
  }

  func setLogout() {
    DispatchQueue.main.async {
      let logoutButton = UIBarButtonItem(title: "Log out",
                                         style: .done,
                                         target: self,
                                         action: #selector(self.logout))
      self.navigationItem.setRightBarButton(logoutButton, animated: true)
    }
  }

  @objc
  private func logout() {
    guard session.isOnline else {
      Alert.showAlert(self, BackendError.transferError.description)
      return
    }

    guard let token = keychain.readToken() else { return }
    session.signout(token)
    keychain.deleteToken()
    rootViewController.switchToLogout()
  }

  /// Загрузка профиля друга из ленты
  func loadUserByProfile(_ userID: String) {
    guard session.isOnline else {
      Alert.showAlert(self, BackendError.transferError.description)
      return
    }

    guard let token = keychain.readToken() else { return }
    ActivityIndicator.start()

    feedUserID = userID

    session.getUserWithID(token, userID) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let user):
          self.userProfile = user

          self.session.getPostsWithUserID(token, user.id) { [weak self] result in
            guard let self = self else { return }

            switch result {
              case .success(let posts):
                self.postsProfile = posts
                self.updateUI()
              case .fail(let error):
                Alert.showAlert(self, error.description)
            }
          }

        case .fail(let error):
          Alert.showAlert(self, error.description)
      }
    }
  }

  /// Загрузка профиля текущего пользователя
  func loadCurrentUser() {
    guard session.isOnline else {
      Alert.showAlert(self, BackendError.transferError.description)
      return
    }
    setLogout()

    guard let token = keychain.readToken() else { return }

    ActivityIndicator.start()

    session.getCurrentUser(token) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let currentUser):
          self.userProfile = currentUser
          
          //MARK: Сохраняются данные текущего пользователя в core data
          // Сохраняются данные текущего пользователя в core data
          self.saveCurrentUserOffline(user: currentUser)

          self.session.getPostsWithUserID(token, currentUser.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
              case .success(let posts):
                self.postsProfile = posts

                self.updateUI()
              case .fail(let error):
                Alert.showAlert(self, error.description)
            }
          }
        case .fail(let error):
          Alert.showAlert(self, error.description)
      }
    }
  }
}

// MARK: ProfileHeaderDelegate
extension ProfileViewController: ProfileHeaderDelegate {
  /// Открывает список подписчиков
  func openFollowersList() {
    guard session.isOnline else {
      Alert.showAlert(self, BackendError.transferError.description)
      return
    }

    guard let token = keychain.readToken() else { return }
    ActivityIndicator.start()

    let userListViewController = UserListViewController()
    guard let userID = userProfile?.id else { return }

    session.getFollowersWithUserID(token, userID) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let users):
          userListViewController.usersList = users
          DispatchQueue.main.async {
            userListViewController.navigationItemTitle = NamesItemTitle.followers
            self.navigationController?.pushViewController(userListViewController, animated: true)
            ActivityIndicator.stop()
          }
        case .fail(let error):
          Alert.showAlert(self, error.description)
      }
    }
  }

  /// Открывает список подписок
  func openFollowingList() {
    guard session.isOnline else {
      Alert.showAlert(self, BackendError.transferError.description)
      return
    }

    guard let token = keychain.readToken() else { return }
    ActivityIndicator.start()

    let userListViewController = UserListViewController()

    guard let userID = userProfile?.id else { return }

    session.getFollowingWithUserID(token, userID) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let users):
          userListViewController.usersList = users
          DispatchQueue.main.async {
            userListViewController.navigationItemTitle = NamesItemTitle.followers
            self.navigationController?.pushViewController(userListViewController, animated: true)
            ActivityIndicator.stop()
          }
        case .fail(let error):
          Alert.showAlert(self, error.description)
      }
    }
  }

  /// Подписывает и отписывает текущего пользователя от друзей
  func followUnfollowUser() {
    guard session.isOnline else {
      Alert.showAlert(self, BackendError.transferError.description)
      return
    }
    
    guard
      let token = keychain.readToken(),
      let userProfile = userProfile  else { return }

    guard userProfile.currentUserFollowsThisUser else {
      session.followCurrentUserWithUserID(token, userProfile.id) { [weak self] result in
        guard let self = self else { return }

        switch result {
          case .success(let user):
            self.userProfile = user
            DispatchQueue.main.async {
              self.currentUser?.followedByCount += 1
              self.profileCollectionView.reloadData()
            }
          case .fail(let error):
            Alert.showAlert(self, error.description)
        }
      }
      return
    }

    session.unfollowCurrentUserWithUserID(token, userProfile.id) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let user):
          self.userProfile = user
          DispatchQueue.main.async {
            self.currentUser?.followsCount -= 1
            self.profileCollectionView.reloadData()
          }
        case .fail(let error):
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
  func saveCurrentUserOffline(user: User) {
    let context = coreDataManager.getContext()
    let userAvatarImageData = try? Data(contentsOf: user.avatar)
    let currentUserOffline = coreDataManager.createObject(from: UserOffline.self)
    currentUserOffline.avatar = userAvatarImageData
    currentUserOffline.currentUserFollowsThisUser = user.currentUserFollowsThisUser
    currentUserOffline.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
    currentUserOffline.followedByCount = Int16(user.followedByCount)
    currentUserOffline.followsCount = Int16(user.followsCount)
    currentUserOffline.fullName = user.fullName
    currentUserOffline.id = user.id
    currentUserOffline.username = user.username

    coreDataManager.save(context: context)
  }

}
