//
//  UserListViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 07.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class UserListViewController: UIViewController {

    var usersList = [User]()
    var navigationItemTitle: String?
    private let keychain = Keychain.shared
    private let networkService = NetworkService()
    private let onlineServise = CheckOnlineServise.shared

    @IBOutlet var userListTableView: UITableView! {
        willSet {
            newValue.register(nibCell: UserListTableViewCell.self)
            newValue.tableFooterView = UIView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTitle()
        setupBackButton()
        title = navigationItemTitle
        view.backgroundColor = SystemColors.backgroundColor
    }
}

// MARK: DataSource
extension UserListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: UserListTableViewCell.self, for: indexPath)
        let user = usersList[indexPath.row]

        cell.setupList(user: user)
        cell.delegate = self
        return cell
    }
}

// MARK: Delegate
extension UserListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userID = usersList[indexPath.row].id
        let profileViewController = ProfileViewController()

        profileViewController.feedUserID = userID
        navigationController?.pushViewController(profileViewController, animated: true)
        userListTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserListViewController: UserListTableViewCellDelegate {

    func followUnfollowUser(cell: UserListTableViewCell) {
        guard onlineServise.isOnline else {
            Alert.showAlert(self, BackendError.transferError.description)
            return
        }

        guard
            let token = keychain.readToken(),
            let indexPath = userListTableView.indexPath(for: cell) else { return }

        let userProfile = usersList[indexPath.row]

        guard userProfile.currentUserFollowsThisUser else {
            networkService.postRequest().followCurrentUserWithUserID(token, userProfile.id) { [weak self] result in
                guard let self = self else { return }

                switch result {
                    case .success(let user):
                        DispatchQueue.main.async {
                            guard let index = self.usersList.firstIndex(where: { (followUser) -> Bool in
                                user.id == followUser.id
                            }) else { return }
                            self.usersList.remove(at: index)
                            self.usersList.insert(user, at: index)
                            self.userListTableView.reloadData()
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
                    DispatchQueue.main.async {
                        guard let index = self.usersList.firstIndex(where: { (followUser) -> Bool in
                            user.id == followUser.id
                        }) else { return }
                        self.usersList.remove(at: index)
                        self.usersList.insert(user, at: index)
                        self.userListTableView.reloadData()
                    }
                case .failure(let error):
                    Alert.showAlert(self, error.description)
            }
        }
    }
}
