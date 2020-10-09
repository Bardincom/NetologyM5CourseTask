//
//  UserOfflineService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 09.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

protocol UserOfflineProtocol {
    func saveCurrentUserOffline(user: User)
}

class UserOfflineService: UserOfflineProtocol {
    private let coreDataManager = CoreDataStack.shared

    func saveCurrentUserOffline(user: User) {
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

        coreDataManager.save()
    }
}
