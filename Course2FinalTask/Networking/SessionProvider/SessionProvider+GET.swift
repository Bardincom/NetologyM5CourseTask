//
//  GET request.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 10.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

extension SessionProvider {

    /// Проверяет валидность токена.
    func checkToken(_ token: String,
                    completionHandler: @escaping (Result<Bool, BackendError>) -> Void) {
        guard let url = preparationURL(path: TokenPath.check) else { return }

        let request = preparationRequest(url, HttpMethod.get, token)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает информацию о текущем пользователе.
    func getCurrentUser(_ token: String,
                        completionHandler: @escaping (Result<User, BackendError>) -> Void) {
        guard let url = preparationURL(path: UserPath.currentUser) else { return }

        let request = preparationRequest(url, HttpMethod.get, token)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает информацию о пользователе с запрошенным ID.
    func getUserWithID (_ token: String,
                        _ userID: String,
                        completionHandler: @escaping (Result<User, BackendError>) -> Void) {
        guard let url = preparationURL(path: UserPath.users + userID) else { return }

        let request = preparationRequest(url, HttpMethod.get, token)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает подписчиков пользователя с запрошенным ID
    func getFollowersWithUserID(_ token: String,
                                _ userID: String,
                                completionHandler: @escaping (Result<[User], BackendError>) -> Void) {
        guard let url = preparationURL(path: UserPath.users + "\(userID)" + UserPath.followers) else { return }

        let request = preparationRequest(url, HttpMethod.get, token)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает подписки пользователя с запрошенным ID
    func getFollowingWithUserID(_ token: String,
                                _ userID: String,
                                completionHandler: @escaping (Result<[User], BackendError>) -> Void) {

        guard let url = preparationURL(path: UserPath.users + "\(userID)" + UserPath.following) else { return }

        let request = preparationRequest(url, HttpMethod.get, token)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает публикации пользователя с запрошенным ID.
    func getPostsWithUserID(_ token: String,
                            _ userID: String,
                            completionHandler: @escaping (Result<[Post], BackendError>) -> Void) {
        guard let url = preparationURL(path: UserPath.users + "\(userID)" + PostPath.posts) else { return }

        let request = preparationRequest(url, HttpMethod.get, token)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает публикации пользователей, на которых подписан текущий пользователь.
    func getFeedPosts(_ token: String,
                      completionHandler: @escaping (Result<[Post], BackendError>) -> Void) {
        guard let url = preparationURL(path: PostPath.feed) else { return }

        let request = preparationRequest(url, HttpMethod.get, token)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает публикацию с запрошенным ID.
    func getPostsWithID (_ token: String,
                         _ postsID: String,
                         completionHandler: @escaping (Result<Post, BackendError>) -> Void) {
        guard let url = preparationURL(path: PostPath.posts + postsID) else { return }

        let request = preparationRequest(url, HttpMethod.get, token)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает пользователей, поставивших лайк на публикацию с запрошенным ID.
    func getLikePostUserWithPostID(_ token: String,
                                   _ postID: String,
                                   completionHandler: @escaping (Result<[User], BackendError>) -> Void) {
        guard let url = preparationURL(path: PostPath.posts + "\(postID)" + PostPath.likes) else { return }

        let request = preparationRequest(url, HttpMethod.get, token)

        dataTask(with: request, completionHandler: completionHandler)
    }
}
