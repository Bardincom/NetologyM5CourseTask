//
//  UserListTableViewCell.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 07.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class UserListTableViewCell: UITableViewCell {

  @IBOutlet var avatarImage: UIImageView!
  @IBOutlet var userNameLabel: UILabel!

  func setupList(user: User) {
    avatarImage.kf.setImage(with: user.avatar)
    userNameLabel.text = user.username
  }
}
