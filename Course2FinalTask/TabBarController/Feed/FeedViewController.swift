//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 24.02.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class FeedViewController: UIViewController {

  private var postsArray = [Post]()
  private var post: Post?
  private var session = SessionProvider.shared
  private var keychain = Keychain.shared
  var newPost: ((Post) -> Void)?
  var alertAction: ((Bool) -> Void)?

  lazy var coreDataProvider = CoreDataProvider.shared
  private var offlinePostsArray = [PostOffline]()

  let refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    return refreshControl
  }()

  @IBOutlet weak private var feedCollectionView: UICollectionView! {
    willSet {
      newValue.register(nibCell: FeedCollectionViewCell.self)
    }
  }

  @IBOutlet weak private var collectionLayout: UICollectionViewFlowLayout! {
    didSet {
      collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    guard let token = keychain.readToken() else { return }

    session.getFeedPosts(token) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let posts):
          self.postsArray = posts
          // Сохранение в CoreData
          posts.forEach { post in
            self.coreDataProvider.savePostOffline(post: post)
        }

        case .fail(let error):
          Alert.showAlert(self, error.description)
      }

      DispatchQueue.main.async {
        if self.isViewLoaded {
          self.feedCollectionView.reloadData()
        }
      }
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = SystemColors.backgroundColor
    feedCollectionView.refreshControl = refreshControl
    // сюда попадает новая публикация и размещается вверху ленты
    newPost = { [weak self] post in
      self?.postsArray.insert(post, at: 0)
      self?.coreDataProvider.savePostOffline(post: post)
      // переходим в начало Ленты
      self?.feedCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
      self?.feedCollectionView.reloadData()
    }
    alertAction?(isViewLoaded)

//    configureNavigation()
    navigationItem.title = "Instagram"
    configureTitle()
  }

//  func configureNavigation() {
//
//    let attributes = [NSAttributedString.Key.foregroundColor: Asset.ColorAssets.appearance.color, NSAttributedString.Key.font: UIFont(name: "Noteworthy", size: 20)]
//      self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key: Any]
//  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    checkOnlineSession()
  }
}

// MARK: DataSource
extension FeedViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return  session.isOnline ? postsArray.count : offlinePostsArray.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeue(cell: FeedCollectionViewCell.self, for: indexPath)

    if session.isOnline {
      let post = postsArray[indexPath.row]
      cell.setupFeed(post: post)
    } else {
      let post = offlinePostsArray[indexPath.row]
      cell.setupFeed(post: post)
    }

    cell.delegate = self
    return cell
  }
}

// MARK: DelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width

    if session.isOnline {
      let post = postsArray[indexPath.row]
      let estimatedFrame = NSString(string: post.description).boundingRect(with: CGSize(width: width - 8, height: width - 8), options: .usesLineFragmentOrigin, attributes: nil, context: nil)
      return CGSize(width: width, height: estimatedFrame.height + width + 130)
    } else {
      let post = offlinePostsArray[indexPath.row]
      let estimatedFrame = NSString(string: post.description).boundingRect(with: CGSize(width: width - 8, height: width - 8), options: .usesLineFragmentOrigin, attributes: nil, context: nil)
      return CGSize(width: width, height: estimatedFrame.height + width + 130)
    }
  }

  /// убираю отступ между ячейками
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

// MARK: FeedCollectionViewProtocol
extension FeedViewController: FeedCollectionViewProtocol {

  /// открывает профиль пользователя
  func openUserProfile(cell: FeedCollectionViewCell) {
    guard session.isOnline else {
      Alert.showAlert(self, BackendError.transferError.description)
      return
    }
    guard let token = keychain.readToken() else { return }

    let profileViewController = ProfileViewController()

    guard let indexPath = feedCollectionView.indexPath(for: cell) else { return }

    let userID = postsArray[indexPath.row].author

    session.getUserWithID(token, userID) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let user):
          profileViewController.feedUserID = user.id
          DispatchQueue.main.async {
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
        case .fail(let error):
          Alert.showAlert(self, error.description)
      }
    }
  }

  /// ставит лайк на публикацию
  func likePost(cell: FeedCollectionViewCell) {
    guard session.isOnline else {
      Alert.showAlert(self, BackendError.transferError.description)
      return
    }

    guard let token = keychain.readToken() else { return }
    guard let indexPath = feedCollectionView.indexPath(for: cell) else { return }

    let postID = postsArray[indexPath.row].id

    guard !postsArray[indexPath.row].currentUserLikesThisPost else {
      session.unlikePostCurrentUserWithPostID(token, postID) { [weak self] result in
        guard let self = self else { return }
        switch result {
          case .success(let unlikePost):
            self.post = unlikePost
          case .fail(let error):
            Alert.showAlert(self, error.description)
        }
      }

      postsArray[indexPath.row].currentUserLikesThisPost = false
      postsArray[indexPath.row].likedByCount -= 1
      cell.tintColor = SystemColors.grayColor

      self.feedCollectionView.reloadData()
      return
    }

    session.likePostCurrentUserWithPostID(token, postID) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let likePost):
          self.post = likePost
        case .fail(let error):
          Alert.showAlert(self, error.description)
      }
    }

    postsArray[indexPath.row].currentUserLikesThisPost = true
    postsArray[indexPath.row].likedByCount += 1
    cell.tintColor = SystemColors.pinkColor

    self.feedCollectionView.reloadData()
  }

  /// открывает список пользователей поставивших лайк
  func userList(cell: FeedCollectionViewCell) {
    guard session.isOnline else {
      Alert.showAlert(self, BackendError.transferError.description)
      return
    }
    ActivityIndicator.start()

    guard let token = keychain.readToken() else { return }
    let userListViewController = UserListViewController()

    guard let indexPath = feedCollectionView.indexPath(for: cell) else { return }

    let currentPostID = postsArray[indexPath.row].id

    session.getLikePostUserWithPostID(token, currentPostID) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let users):
          userListViewController.usersList = users
        case .fail(let error):
          Alert.showAlert(self, error.description)
      }

      DispatchQueue.main.async {
        userListViewController.navigationItemTitle = Names.likes
        self.navigationController?.pushViewController(userListViewController, animated: true)
        ActivityIndicator.stop()
      }
    }
  }
}

private extension FeedViewController {
  @objc
  func refresh(_ sender: UIRefreshControl) {
    guard session.isOnline else {
      Alert.showAlert(self, BackendError.transferError.description)
      return
    }
    
    guard let token = keychain.readToken() else { return }

    session.getFeedPosts(token) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let posts):
          self.postsArray = posts
        case .fail(let error):
          Alert.showAlert(self, error.description)
      }

      DispatchQueue.main.async {
        if self.isViewLoaded {
          self.feedCollectionView.reloadData()
        }
      }
    }
    sender.endRefreshing()
  }
}

// MARK: CoreData

extension FeedViewController {
  func checkOnlineSession() {
    guard session.isOnline else {
      coreDataProvider.fetchData(for: PostOffline.self, hendler: { (offlinePost) in
        offlinePostsArray = offlinePost
      })
      return
    }
  }
}
