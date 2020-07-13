//
//  UserListViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 07.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

  var usersList: [User1]?
  var navigationItemTitle: String?

  @IBOutlet var userListTableView: UITableView! {
    willSet {
      newValue.register(nibCell: UserListTableViewCell.self)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItemTitle = navigationItem.title
  }
}

// MARK: DataSource
extension UserListViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    selectUsers(users: usersList).count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(reusable: UserListTableViewCell.self, for: indexPath)

    let user = selectUsers(users: usersList)[indexPath.row]
    cell.setupList(user: user)

    return cell
  }
}

// MARK: Delegate
extension UserListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let userID = selectUsers(users: usersList)[indexPath.row].id

    let profileViewController = ProfileViewController()
    profileViewController.feedUserID = userID
    navigationController?.pushViewController(profileViewController, animated: true)
    userListTableView.deselectRow(at: indexPath, animated: true)
  }
}
