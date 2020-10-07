//
//  POST request.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 10.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

// MARK: POST
extension SessionProvider {
    /// Авторизует пользователя и выдает токен.
    func signin(login: String,
                password: String,
                completionHandler: @escaping ResultBlock<Token>) {
        ActivityIndicator.start()
        guard let url = preparationURL(path: TokenPath.signin) else { return }
        let authorization = Authorization(login: login, password: password)

        var request = preparationRequest(url, HttpMethod.post)
        request.httpBody = try? encoder.encode(authorization)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Деавторизует пользователя и инвалидирует токен.
    func signout(_ token: String, completionHandler: @escaping ResultBlock<Bool>) {
        guard let url = preparationURL(path: TokenPath.signout) else { return }

        let request = preparationRequest(url, HttpMethod.post, token)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Подписывает текущего пользователя на пользователя с запрошенным ID.
    func followCurrentUserWithUserID(_ token: String,
                                     _ userID: String,
                                     _ completionHandler: @escaping ResultBlock<User>) {
        guard let url = preparationURL(path: UserPath.follow) else { return }
        let userIDRequest = UserIDRequest(userID: userID)

        var request = preparationRequest(url, HttpMethod.post, token)
        request.httpBody = try? encoder.encode(userIDRequest)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Отписывает текущего пользователя от пользователя с запрошенным ID.
    func unfollowCurrentUserWithUserID(_ token: String,
                                       _ userID: String,
                                       _ completionHandler: @escaping ResultBlock<User>) {
        guard let url = preparationURL(path: UserPath.unfollow) else { return }
        let userIDRequest = UserIDRequest(userID: userID)
        var request = preparationRequest(url, HttpMethod.post, token)
        request.httpBody = try? encoder.encode(userIDRequest)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Ставит лайк от текущего пользователя на публикации с запрошенным ID.
    func likePostCurrentUserWithPostID(_ token: String,
                                       _ postID: String,
                                       _ completionHandler: @escaping ResultBlock<Post>) {
        guard let url = preparationURL(path: PostPath.like) else { return }
        let postIDRequest = PostIDRequest(postID: postID)

        var request = preparationRequest(url, HttpMethod.post, token)
        request.httpBody = try? encoder.encode(postIDRequest)

        dataTask(with: request, completionHandler: completionHandler)
    }

    /// Удаляет лайк от текущего пользователя на публикации с запрошенным ID.
    func unlikePostCurrentUserWithPostID(_ token: String,
                                         _ postID: String,
                                         _ completionHandler: @escaping ResultBlock<Post>) {
        guard let url = preparationURL(path: PostPath.unlike) else { return }
        let postIDRequest = PostIDRequest(postID: postID)

        var request = preparationRequest(url, HttpMethod.post, token)
        request.httpBody = try? encoder.encode(postIDRequest)

        dataTask(with: request, completionHandler: completionHandler)
    }

    func createPost(_ token: String,
                    _ image: UIImage,
                    _ description: String,
                    _ completionHandler: @escaping ResultBlock<Post>) {
        guard let url = preparationURL(path: PostPath.create) else { return }
        guard let imageData = image.jpegData(compressionQuality: 1)?.base64EncodedString() else { return }
        let newPostRequest = NewPostRequest(image: imageData, description: description)

        var request = preparationRequest(url, HttpMethod.post, token)
        request.httpBody = try? encoder.encode(newPostRequest)

        dataTask(with: request, completionHandler: completionHandler)
    }
}
