//
//  Paths.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

enum TokenPath {
  static let signin = "/signin"
  static let signout = "/signout"
  static let check = "/checkToken"
}

enum UserPath {
  static let users = "/users/"
  static let currentUser = "/users/me"
  static let follow = "/users/follow"
  static let unfollow = "/users/unfollow"
  static let followers = "/followers"
  static let following = "/following"
}

enum PostPath {
  static let posts = "/posts/"
  static let feed = "/posts/feed"
  static let like = "/posts/like"
  static let unlike = "/posts/unlike"
  static let likes = "/likes"
  static let create = "/posts/create"
}
