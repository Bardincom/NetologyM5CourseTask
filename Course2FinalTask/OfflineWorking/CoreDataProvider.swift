//
//  CoreDataProvider.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 24.09.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import CoreData

class CoreDataProvider {
  
  static let shared = CoreDataProvider()
  lazy var coreDataManager = CoreDataManager.shared

  private init () {}

  func savePostOffline(post: Post) {
    let context = coreDataManager.getContext()
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

    coreDataManager.save(context: context)
  }

  func saveCurrentUserOffline(user: User) {
    let context = coreDataManager.getContext()
    let userAvatarImageData = try? Data(contentsOf: user.avatar)
    let currentUserOffline = coreDataManager.createObject(from: UserOffline.self)
    currentUserOffline.avatar = userAvatarImageData
    currentUserOffline.currentUserFollowsThisUser = user.currentUserFollowsThisUser
    currentUserOffline.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
    currentUserOffline.followedByCount = Int16(user.followedByCount)
    currentUserOffline.followsCount = Int16(user.followsCount)
    currentUserOffline.fullName = user.fullName
    currentUserOffline.id = user.id
    currentUserOffline.username = user.username

    coreDataManager.save(context: context)
  }

  func fetchData<T: NSManagedObject>(for: T.Type, hendler: ([T]) -> Void) {
    hendler(coreDataManager.fetchData(for: T.self))
  }
}
