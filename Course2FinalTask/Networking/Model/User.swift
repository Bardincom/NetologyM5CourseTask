//
//  User.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 03.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

struct User1: Codable {
    var id: String
    var username: String
    var fullName: String
    var avatar: URL?
    var currentUserFollowsThisUser: Bool
    var currentUserIsFollowedByThisUser: Bool
    var followsCount: Int
    var followedByCount: Int
}
