//
//  CoreDataService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 09.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
    private var coreDataManager = CoreDataStack.shared
    private let postOfflineService: PostOfflineProtocol
    private let userOfflineService: UserOfflineProtocol

    init(postOfflineService: PostOfflineProtocol = PostOfflineService(),
         userOfflineService: UserOfflineProtocol = UserOfflineService()) {
        self.postOfflineService = postOfflineService
        self.userOfflineService = userOfflineService
    }

    func saveOfflinePost() -> PostOfflineProtocol {
        return postOfflineService
    }

    func saveOfflineUser() -> UserOfflineProtocol {
        return userOfflineService
    }

    func fetchData<T: NSManagedObject>(for: T.Type, hendler: @escaping ([T]) -> Void) {
        hendler(coreDataManager.fetchData(for: T.self))
    }
}
