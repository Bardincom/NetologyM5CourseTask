//
//  PostOfflineService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 09.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

protocol PostOfflineProtocol {
    func savePostOffline(post: Post)
}

class PostOfflineService: PostOfflineProtocol {
    private let coreDataManager = CoreDataStack.shared

    func savePostOffline(post: Post) {
        let postOff = coreDataManager.createObject(from: PostOffline.self)
        let postAuthorAvatarImageData = try? Data(contentsOf: post.authorAvatar)
        let postImageData = try? Data(contentsOf: post.image)

        postOff.author = post.author
        postOff.authorAvatar = postAuthorAvatarImageData
        postOff.authorUsername = post.authorUsername
        postOff.createdTime = post.createdTime
        postOff.currentUserLikesThisPost = post.currentUserLikesThisPost
        postOff.descript = post.description
        postOff.likedByCount = Int16(post.likedByCount)
        postOff.id = post.id
        postOff.image = postImageData

        coreDataManager.save()
    }
}
