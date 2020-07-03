//
//  DataProvider Properties.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 11.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import DataProvider

public let queue = DispatchQueue.global(qos: .userInitiated)

/// Поставщик публикаций
public let postsDataProviders = DataProviders.shared.postsDataProvider

/// Поставщик пользователей
public let userDataProviders = DataProviders.shared.usersDataProvider

/// Поставщик фотографий для новых публикаций
public let photoProvider = DataProviders.shared.photoProvider

/// Фото для новых публикаций
public var photoNewPosts = photoProvider.photos()

func selectUsers(users: [User]?) -> [User] {
    guard let users = users else {
        return [User]()
    }
    return users
}
