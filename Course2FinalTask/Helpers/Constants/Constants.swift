//
//  Constants.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 19.09.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit

enum Model {
    static let name = "DataBase"
}

enum SystemColors {
  static let backgroundColor = UIColor.systemBackground
  static let grayColor = UIColor.systemGray
  static let pinkColor = UIColor.systemPink
}

let withConfiguration = UIImage.SymbolConfiguration(weight: .regular)

enum TabBarButton {
    static let feed = UIImage(systemName: "house.fill", withConfiguration: withConfiguration)
    static let newPost = UIImage(systemName: "plus.app.fill", withConfiguration: withConfiguration)
    static let profile = UIImage(systemName: "person.fill", withConfiguration: withConfiguration)
}

public enum ControllerSet {
    static let feedViewController = "Feed"
    static let profileViewController = "Profile"
    static let newPostViewController = "New"
}

public enum NamesItemTitle {
   static let likes = "Likes"
   static let followers = "Followers"
   static let following = "Following"
   static let newPost = "New Post"
   static let filters = "Filters"
}

public let cornerRadiusButton: CGFloat = 5
