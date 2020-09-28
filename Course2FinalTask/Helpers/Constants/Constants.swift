//
//  Constants.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 19.09.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit

public enum Model {
  static let name = "DataBase"
}

public enum SystemColors {
  static let backgroundColor = UIColor.systemBackground
  static let grayColor = UIColor.systemGray
  static let pinkColor = UIColor.systemPink
  static let redColor = UIColor.systemRed
}

public enum Constants {
  static let simbolWeight = UIImage.SymbolConfiguration(weight: .regular)
  static let cornerRadiusButton: CGFloat = 5
}

public enum Buttons {
  static let feed = UIImage(systemName: "house.fill", withConfiguration: Constants.simbolWeight)
  static let newPost = UIImage(systemName: "plus.app.fill", withConfiguration: Constants.simbolWeight)
  static let profile = UIImage(systemName: "person.fill", withConfiguration: Constants.simbolWeight)
  static let back = UIImage(systemName: "chevron.left", withConfiguration: Constants.simbolWeight)
  static let next = UIImage(systemName: "arrowshape.turn.up.right.fill", withConfiguration: Constants.simbolWeight)
  static let exit = UIImage(systemName: "multiply.circle", withConfiguration: Constants.simbolWeight)
  static let sharedPost = UIImage(systemName: "checkmark.circle.fill", withConfiguration: Constants.simbolWeight)
  static let camera = UIImage(systemName: "camera", withConfiguration: Constants.simbolWeight)
}

public enum ControllerSet {
  static let feedViewController = "Feed"
  static let profileViewController = "Profile"
  static let newPostViewController = "Add Post"
}

public enum Names {
  static let likes = "Likes"
  static let followers = "Followers"
  static let following = "Following"
  static let newPost = "New Post"
  static let filters = "Filters"
  static let unfollow = "Unfollow"
  static let follow =  "Follow"
}
