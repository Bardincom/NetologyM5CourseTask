//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 24.02.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class FeedViewController: UIViewController {

    private enum Constants {
        static let topOffset: CGFloat = 8
        static let avatarHeight: CGFloat = 35
        static let topPostImageOffset: CGFloat = 8
        static let isLikeIconHeight: CGFloat = 44
        static let descriptionHeight: CGFloat = 44
    }

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

    private var postsArray = [Post]()
    private var post: Post?
    private var networkService = NetworkService()
    private let onlineService = CheckOnlineService.shared
    private var keychain = Keychain.shared
    public var newPost: Block<Post>?
    public var alertAction: Block<Bool>?
    private var coreDataService = CoreDataService()
    private var offlinePostsArray = [PostOffline]()

    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        guard let token = keychain.readToken() else { return }

        networkService.getRequest().getFeedPosts(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let posts):
                    self.postsArray = posts
                    // save in CoreData
                    self.coreDataService.saveOfflinePost().savePostsOffline(posts)
                case .failure(let error):
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

        feedCollectionView.refreshControl = refreshControl
        // сюда попадает новая публикация и размещается вверху ленты
        newPost = { [weak self] post in
            self?.postsArray.insert(post, at: 0)
            self?.coreDataService.saveOfflinePost().savePostOffline(post: post)
            // переходим в начало Ленты
            self?.feedCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            self?.feedCollectionView.reloadData()
        }
        alertAction?(isViewLoaded)
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkOnlineSession()
    }
}

// MARK: DataSource
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onlineService.isOnline ? postsArray.count : offlinePostsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeue(cell: FeedCollectionViewCell.self, for: indexPath)

        if onlineService.isOnline {
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

        let width = view.bounds.width
        let imageHeight = width
        let height = Constants.topOffset + Constants.avatarHeight + Constants.topPostImageOffset + imageHeight + Constants.isLikeIconHeight + Constants.descriptionHeight

        return CGSize(width: width, height: height)
    }
}

// MARK: FeedCollectionViewProtocol
extension FeedViewController: FeedCollectionViewProtocol {

    /// открывает профиль пользователя
    func openUserProfile(cell: FeedCollectionViewCell) {
        guard onlineService.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }
        guard let token = keychain.readToken() else { return }

        let profileViewController = ProfileViewController()

        guard let indexPath = feedCollectionView.indexPath(for: cell) else { return }

        let userID = postsArray[indexPath.row].author

        networkService.getRequest().getUserWithID(token, userID) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let user):
                    profileViewController.feedUserID = user.id
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                    }
                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }
        }
    }

    /// ставит лайк на публикацию
    func likePost(cell: FeedCollectionViewCell) {
        guard onlineService.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard let token = keychain.readToken() else { return }
        guard let indexPath = feedCollectionView.indexPath(for: cell) else { return }

        let postID = postsArray[indexPath.row].id

        guard !postsArray[indexPath.row].currentUserLikesThisPost else {
            networkService.postRequest().unlikePostCurrentUserWithPostID(token, postID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let unlikePost):
                        self.post = unlikePost
                        self.coreDataService.saveOfflinePost().savePostOffline(post: unlikePost)
                    case .failure(let error):
                        Alert.showAlert(self, error.description)
                }
            }

            postsArray[indexPath.row].currentUserLikesThisPost = false
            postsArray[indexPath.row].likedByCount -= 1
            cell.tintColor = SystemColors.grayColor

            self.feedCollectionView.reloadData()
            return
        }

        networkService.postRequest().likePostCurrentUserWithPostID(token, postID) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let likePost):
                    self.post = likePost
                    self.coreDataService.saveOfflinePost().savePostOffline(post: likePost)
                case .failure(let error):
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
        guard onlineService.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard let token = keychain.readToken() else { return }
        let userListViewController = UserListViewController()

        guard let indexPath = feedCollectionView.indexPath(for: cell) else { return }

        let currentPostID = postsArray[indexPath.row].id

        networkService.getRequest().getLikePostUserWithPostID(token, currentPostID) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let users):
                    userListViewController.usersList = users
                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }

            DispatchQueue.main.async {
                userListViewController.navigationItemTitle = Localization.Names.likes
                self.navigationController?.pushViewController(userListViewController, animated: true)
            }
        }
    }
}

private extension FeedViewController {

    func setupUI() {
        view.backgroundColor = SystemColors.backgroundColor
        navigationItem.title = Localization.Names.feedTitle
        addCameraButton()
        configureTitle()
    }

    func addCameraButton() {
        let backButton = UIBarButtonItem(image: Buttons.camera,
                                         style: .plain,
                                         target: self,
                                         action: #selector(addNewFoto))
        backButton.tintColor = Asset.ColorAssets.appearance.color
        navigationItem.leftBarButtonItem = .some(backButton)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    @objc
    func addNewFoto() {
        print("Открываю камеру")
    }

    @objc
    func refresh(_ sender: UIRefreshControl) {
        guard onlineService.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            sender.endRefreshing()
            return
        }

        guard let token = keychain.readToken() else { return }

        networkService.getRequest().getFeedPosts(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let posts):
                    self.postsArray = posts
                case .failure(let error):
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
        guard onlineService.isOnline else {
            coreDataService.fetchData(for: PostOffline.self, handler: { [weak self] (offlinePost) in
                self?.offlinePostsArray = offlinePost
            })
            return
        }
    }
}
