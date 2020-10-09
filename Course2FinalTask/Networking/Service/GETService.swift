//
//  GETService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

protocol GETProtocol {
    func getCurrentUser(_ token: String, completionHandler: @escaping ResultBlock<User>)
    func getUserWithID (_ token: String, _ userID: String, completionHandler: @escaping ResultBlock<User>)
    func getFollowersWithUserID(_ token: String, _ userID: String, completionHandler: @escaping ResultBlock<[User]>)
    func getFollowingWithUserID(_ token: String, _ userID: String, completionHandler: @escaping ResultBlock<[User]>)
    func getPostsWithUserID(_ token: String, _ userID: String, completionHandler: @escaping ResultBlock<[Post]>)
    func getFeedPosts(_ token: String, completionHandler: @escaping ResultBlock<[Post]>)
    func getPostWithID (_ token: String, _ postsID: String, completionHandler: @escaping ResultBlock<Post>)
    func getLikePostUserWithPostID(_ token: String, _ postID: String, completionHandler: @escaping ResultBlock<[User]>)
}

class GETService: GETProtocol {

    private let urlService: URLServiceProtocol
    private let requestServise: RequestServiceProtocol
    private let dataProvider: DataTaskServiceProtocol

    init(urlService: URLServiceProtocol = URLService(),
         requestServise: RequestServiceProtocol = RequestService(),
         dataProvider: DataTaskServiceProtocol = DataTaskService()) {
        self.urlService = urlService
        self.requestServise = requestServise
        self.dataProvider = dataProvider
    }

    /// Возвращает информацию о текущем пользователе.
    func getCurrentUser(_ token: String,
                        completionHandler: @escaping ResultBlock<User>) {
        guard let url = urlService.preparationURL(path: UserPath.currentUser) else { return }
        let request = requestServise.preparationRequest(url, HttpMethod.get, token)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает информацию о пользователе с запрошенным ID.
    func getUserWithID (_ token: String,
                        _ userID: String,
                        completionHandler: @escaping ResultBlock<User>) {
        guard let url = urlService.preparationURL(path: UserPath.users + userID) else { return }
        let request = requestServise.preparationRequest(url, HttpMethod.get, token)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает подписчиков пользователя с запрошенным ID
    func getFollowersWithUserID(_ token: String,
                                _ userID: String,
                                completionHandler: @escaping ResultBlock<[User]>) {
        guard let url = urlService.preparationURL(path: UserPath.users + "\(userID)" + UserPath.followers) else { return }
        let request = requestServise.preparationRequest(url, HttpMethod.get, token)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает подписки пользователя с запрошенным ID
    func getFollowingWithUserID(_ token: String,
                                _ userID: String,
                                completionHandler: @escaping ResultBlock<[User]>) {
        guard let url = urlService.preparationURL(path: UserPath.users + "\(userID)" + UserPath.following) else { return }
        let request = requestServise.preparationRequest(url, HttpMethod.get, token)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает публикации пользователя с запрошенным ID.
    func getPostsWithUserID(_ token: String,
                            _ userID: String,
                            completionHandler: @escaping ResultBlock<[Post]>) {
        guard let url = urlService.preparationURL(path: UserPath.users + "\(userID)" + PostPath.posts) else { return }
        let request = requestServise.preparationRequest(url, HttpMethod.get, token)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает публикации пользователей, на которых подписан текущий пользователь.
    func getFeedPosts(_ token: String,
                      completionHandler: @escaping ResultBlock<[Post]>) {
        guard let url = urlService.preparationURL(path: PostPath.feed) else { return }
        let request = requestServise.preparationRequest(url, HttpMethod.get, token)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает публикацию с запрошенным ID.
    func getPostWithID (_ token: String,
                         _ postsID: String,
                         completionHandler: @escaping ResultBlock<Post>) {
        guard let url = urlService.preparationURL(path: PostPath.posts + postsID) else { return }
        let request = requestServise.preparationRequest(url, HttpMethod.get, token)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Возвращает пользователей, поставивших лайк на публикацию с запрошенным ID.
    func getLikePostUserWithPostID(_ token: String,
                                   _ postID: String,
                                   completionHandler: @escaping ResultBlock<[User]>) {
        guard let url = urlService.preparationURL(path: PostPath.posts + "\(postID)" + PostPath.likes) else { return }
        let request = requestServise.preparationRequest(url, HttpMethod.get, token)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }
}
