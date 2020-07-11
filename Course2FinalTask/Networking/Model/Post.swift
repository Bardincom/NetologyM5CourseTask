//
//  Post.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 03.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

struct Post1: Codable {
    var id: String
    var description: String
    var image: URL
    var createdTime: Date
    var currentUserLikesThisPost: Bool
    var likedByCount: Int
    var author: String
    var authorUsername: String
    var authorAvatar: URL
}
