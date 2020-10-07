//
//  POSTService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit

protocol POSTProtocol {
    func followCurrentUserWithUserID(_ token: String, _ userID: String, _ completionHandler: @escaping ResultBlock<User>)
    func unfollowCurrentUserWithUserID(_ token: String, _ userID: String, _ completionHandler: @escaping ResultBlock<User>)
    func likePostCurrentUserWithPostID(_ token: String, _ postID: String, _ completionHandler: @escaping ResultBlock<Post>)
    func unlikePostCurrentUserWithPostID(_ token: String, _ postID: String, _ completionHandler: @escaping ResultBlock<Post>)
    func createPost(_ token: String, _ image: UIImage, _ description: String, _ completionHandler: @escaping ResultBlock<Post>)
}

class POSTService: POSTProtocol {

    private let encoder = JSONEncoder()
    private let urlService: URLServiceProtocol
    private let requestServise: RequestServiceProtocol
    private let dataProvider: DataProviderProtocol

    init(urlService: URLServiceProtocol = URLService(),
         requestServise: RequestServiceProtocol = RequestService(),
         dataProvider: DataProviderProtocol = DataProvider()) {
        self.urlService = urlService
        self.requestServise = requestServise
        self.dataProvider = dataProvider
    }

    /// Подписывает текущего пользователя на пользователя с запрошенным ID.
    func followCurrentUserWithUserID(_ token: String,
                                     _ userID: String,
                                     _ completionHandler: @escaping ResultBlock<User>) {
        guard let url = urlService.preparationURL(path: UserPath.follow) else { return }
        let userIDRequest = UserIDRequest(userID: userID)
        var request = requestServise.preparationRequest(url, HttpMethod.post, token)
        request.httpBody = try? encoder.encode(userIDRequest)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Отписывает текущего пользователя от пользователя с запрошенным ID.
    func unfollowCurrentUserWithUserID(_ token: String,
                                       _ userID: String,
                                       _ completionHandler: @escaping ResultBlock<User>) {
        guard let url = urlService.preparationURL(path: UserPath.unfollow) else { return }
        let userIDRequest = UserIDRequest(userID: userID)
        var request = requestServise.preparationRequest(url, HttpMethod.post, token)
        request.httpBody = try? encoder.encode(userIDRequest)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Ставит лайк от текущего пользователя на публикации с запрошенным ID.
    func likePostCurrentUserWithPostID(_ token: String,
                                       _ postID: String,
                                       _ completionHandler: @escaping ResultBlock<Post>) {
        guard let url = urlService.preparationURL(path: PostPath.like) else { return }
        let postIDRequest = PostIDRequest(postID: postID)
        var request = requestServise.preparationRequest(url, HttpMethod.post, token)
        request.httpBody = try? encoder.encode(postIDRequest)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Удаляет лайк от текущего пользователя на публикации с запрошенным ID.
    func unlikePostCurrentUserWithPostID(_ token: String,
                                         _ postID: String,
                                         _ completionHandler: @escaping ResultBlock<Post>) {
        guard let url = urlService.preparationURL(path: PostPath.unlike) else { return }
        let postIDRequest = PostIDRequest(postID: postID)
        var request = requestServise.preparationRequest(url, HttpMethod.post, token)
        request.httpBody = try? encoder.encode(postIDRequest)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    func createPost(_ token: String,
                    _ image: UIImage,
                    _ description: String,
                    _ completionHandler: @escaping ResultBlock<Post>) {
        guard let url = urlService.preparationURL(path: PostPath.create) else { return }
        guard let imageData = image.jpegData(compressionQuality: 1)?.base64EncodedString() else { return }
        let newPostRequest = NewPostRequest(image: imageData, description: description)
        var request = requestServise.preparationRequest(url, HttpMethod.post, token)
        request.httpBody = try? encoder.encode(newPostRequest)
        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }
}
