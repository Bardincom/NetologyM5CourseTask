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
              completionHandler: @escaping (Result<Token>) -> Void) {
    ActivityIndicator.start()
    guard let url = preparationURL(path: TokenPath.signin) else { return }
    let authorization = Authorization(login: login, password: password)

    var request = URLRequest(url: url)
    request.httpMethod = HttpMethod.post
    request.httpBody = try? encoder.encode(authorization)
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = response as? HTTPURLResponse else {

        let backendError = BackendError.transferError
        completionHandler(.fail(backendError))
        ActivityIndicator.stop()
        return }

      guard httpResponse.statusCode == 200 else {
        let backendError: BackendError

        switch httpResponse.statusCode {
          case 400: backendError = .badRequest
          case 401: backendError = .unauthorized
          case 404: backendError = .notFound
          case 406: backendError = .notAcceptable
          case 422: backendError = .unprocessable
          default: backendError = .transferError
        }

        completionHandler(.fail(backendError))
        ActivityIndicator.stop()
        return
      }

      guard let data = data else { return }

      do {
        let tokenResult = try self.decoder.decode(Token.self, from: data)
        completionHandler(.success(tokenResult))
        ActivityIndicator.stop()
      } catch {
        completionHandler(.fail(BackendError.unauthorized))
      }
    }
    dataTask.resume()
  }

  /// Деавторизует пользователя и инвалидирует токен.
  func signout(_ token: String) {
    guard let url = preparationURL(path: TokenPath.signout) else { return }

    let request = preparationRequest(url, HttpMethod.post, token)

    let dataTask = sharedSession.dataTask(with: request)
    dataTask.resume()
  }

  /// Подписывает текущего пользователя на пользователя с запрошенным ID.
  func followCurrentUserWithUserID(_ token: String,
                                   _ userID: String,
                                   _ completionHandler: @escaping (Result<User>) -> Void) {
    guard let url = preparationURL(path: UserPath.follow) else { return }
    let userIDRequest = UserIDRequest(userID: userID)
    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders
    request.httpMethod = HttpMethod.post
    request.httpBody = try? encoder.encode(userIDRequest)
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = response as? HTTPURLResponse else {

        let backendError = BackendError.transferError
        completionHandler(.fail(backendError))
        ActivityIndicator.stop()
        return }

      guard httpResponse.statusCode == 200 else {
        let backendError: BackendError

        switch httpResponse.statusCode {
          case 400: backendError = .badRequest
          case 401: backendError = .unauthorized
          case 404: backendError = .notFound
          case 406: backendError = .notAcceptable
          case 422: backendError = .unprocessable
          default: backendError = .transferError
        }

        completionHandler(.fail(backendError))

        return
      }

      guard let data = data else { return }

      do {
        let user = try self.decoder.decode(User.self, from: data)
        completionHandler(.success(user))
      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }
    dataTask.resume()
  }

  /// Отписывает текущего пользователя от пользователя с запрошенным ID.
  func unfollowCurrentUserWithUserID(_ token: String,
                                     _ userID: String,
                                     _ completionHandler: @escaping (Result<User>) -> Void) {
    guard let url = preparationURL(path: UserPath.unfollow) else { return }
    let userIDRequest = UserIDRequest(userID: userID)

    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders
    request.httpMethod = HttpMethod.post
    request.httpBody = try? encoder.encode(userIDRequest)
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = response as? HTTPURLResponse else {

        let backendError = BackendError.transferError
        completionHandler(.fail(backendError))
        ActivityIndicator.stop()
        return }

      guard httpResponse.statusCode == 200 else {
        let backendError: BackendError

        switch httpResponse.statusCode {
          case 400: backendError = .badRequest
          case 401: backendError = .unauthorized
          case 404: backendError = .notFound
          case 406: backendError = .notAcceptable
          case 422: backendError = .unprocessable
          default: backendError = .transferError
        }

        completionHandler(.fail(backendError))

        return
      }

      guard let data = data else { return }

      do {
        let user = try self.decoder.decode(User.self, from: data)
        completionHandler(.success(user))
      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }
    dataTask.resume()
  }

  /// Ставит лайк от текущего пользователя на публикации с запрошенным ID.
  func likePostCurrentUserWithPostID(_ token: String,
                                     _ postID: String,
                                     _ completionHandler: @escaping (Result<Post>) -> Void) {
    guard let url = preparationURL(path: PostPath.like) else { return }
    let postIDRequest = PostIDRequest(postID: postID)

    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders
    request.httpMethod = HttpMethod.post
    request.httpBody = try? encoder.encode(postIDRequest)
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = response as? HTTPURLResponse else {

        let backendError = BackendError.transferError
        completionHandler(.fail(backendError))
        ActivityIndicator.stop()
        return }

      guard httpResponse.statusCode == 200 else {
        let backendError: BackendError

        switch httpResponse.statusCode {
          case 400: backendError = .badRequest
          case 401: backendError = .unauthorized
          case 404: backendError = .notFound
          case 406: backendError = .notAcceptable
          case 422: backendError = .unprocessable
          default: backendError = .transferError
        }

        completionHandler(.fail(backendError))

        return
      }

      guard let data = data else { return }

      do {
        let post = try self.decoder.decode(Post.self, from: data)
        completionHandler(.success(post))
      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }
    dataTask.resume()
  }

  /// Удаляет лайк от текущего пользователя на публикации с запрошенным ID.
  func unlikePostCurrentUserWithPostID(_ token: String,
                                       _ postID: String,
                                       _ completionHandler: @escaping (Result<Post>) -> Void) {
    guard let url = preparationURL(path: PostPath.unlike) else { return }
    let postIDRequest = PostIDRequest(postID: postID)

    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders
    request.httpMethod = HttpMethod.post
    request.httpBody = try? encoder.encode(postIDRequest)
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = response as? HTTPURLResponse else {

        let backendError = BackendError.transferError
        completionHandler(.fail(backendError))
        ActivityIndicator.stop()
        return }

      guard httpResponse.statusCode == 200 else {
        let backendError: BackendError

        switch httpResponse.statusCode {
          case 400: backendError = .badRequest
          case 401: backendError = .unauthorized
          case 404: backendError = .notFound
          case 406: backendError = .notAcceptable
          case 422: backendError = .unprocessable
          default: backendError = .transferError
        }

        completionHandler(.fail(backendError))

        return
      }

      guard let data = data else { return }

      do {
        let post = try self.decoder.decode(Post.self, from: data)
        completionHandler(.success(post))
      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }
    dataTask.resume()
  }

  func createPost(_ token: String,
                  _ image: UIImage,
                  _ description: String,
                  _ completionHandler: @escaping (Result<Post>) -> Void) {
    guard let url = preparationURL(path: PostPath.create) else { return }
    
    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders
    request.httpMethod = HttpMethod.post

    guard let imageData = image.jpegData(compressionQuality: 1)?.base64EncodedString() else { return }
    let newPostRequest = NewPostRequest(image: imageData, description: description)
//    let json = "{\"image\" : \"\(imageData)\" , \"description\" : \"\(description)\"}"
    request.httpBody = try? encoder.encode(newPostRequest)
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = response as? HTTPURLResponse else {

        let backendError = BackendError.transferError
        completionHandler(.fail(backendError))
        ActivityIndicator.stop()
        return }

      guard httpResponse.statusCode == 200 else {
        let backendError: BackendError

        switch httpResponse.statusCode {
          case 400: backendError = .badRequest
          case 401: backendError = .unauthorized
          case 404: backendError = .notFound
          case 406: backendError = .notAcceptable
          case 422: backendError = .unprocessable
          default: backendError = .transferError
        }

        completionHandler(.fail(backendError))

        return
      }

      guard let data = data else { return }

      do {
        let post = try self.decoder.decode(Post.self, from: data)
        completionHandler(.success(post))
      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }
    dataTask.resume()
  }

}
