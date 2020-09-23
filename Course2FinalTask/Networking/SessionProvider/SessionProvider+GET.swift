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
                  completionHandler: @escaping (Result<Bool>) -> Void) {
    guard let url = preparationURL(path: TokenPath.check) else { return }

    let request = preparationRequest(url, HttpMethod.get, token)

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      if let error = error {
        self.isOnline = false
        print("Возникла ошибка: \(error.localizedDescription)")
      }

      guard let httpResponse = self.checkResponse(response: response, completionHandler: completionHandler) else { return }

      guard self.checkBackendErrorStatus(httpResponse: httpResponse, completionHandler: completionHandler) else { return }

      completionHandler(.success(true))
    }

    dataTask.resume()
  }

  /// Возвращает информацию о текущем пользователе.
  func getCurrentUser(_ token: String,
                      completionHandler: @escaping (Result<User>) -> Void) {
    guard let url = preparationURL(path: UserPath.currentUser) else { return }

    let request = preparationRequest(url, HttpMethod.get, token)

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = self.checkResponse(response: response, completionHandler: completionHandler) else { return }

      guard self.checkBackendErrorStatus(httpResponse: httpResponse, completionHandler: completionHandler) else { return }

      guard let data = data else { return }

      do {
        let currentUser = try self.decoder.decode(User.self, from: data)
        completionHandler(.success(currentUser))
        ActivityIndicator.stop()
      } catch {
        completionHandler(.fail(BackendError.unauthorized))
      }
    }

    dataTask.resume()
  }

  /// Возвращает информацию о пользователе с запрошенным ID.
  func getUserWithID (_ token: String,
                      _ userID: String,
                      completionHandler: @escaping (Result<User>) -> Void) {
    guard let url = preparationURL(path: UserPath.users + userID) else { return }
    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = self.checkResponse(response: response, completionHandler: completionHandler) else { return }

      guard self.checkBackendErrorStatus(httpResponse: httpResponse, completionHandler: completionHandler) else { return }

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

  /// Возвращает подписчиков пользователя с запрошенным ID
  func getFollowersWithUserID(_ token: String,
                              _ userID: String,
                              completionHandler: @escaping (Result<[User]>) -> Void) {
    guard let url = preparationURL(path: UserPath.users + "\(userID)" + UserPath.followers) else { return }

    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = self.checkResponse(response: response, completionHandler: completionHandler) else { return }

      guard self.checkBackendErrorStatus(httpResponse: httpResponse, completionHandler: completionHandler) else { return }

      guard let data = data else { return }

      do {
        let users = try self.decoder.decode([User].self, from: data)
        completionHandler(.success(users))
      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }

  /// Возвращает подписки пользователя с запрошенным ID
  func getFollowingWithUserID(_ token: String,
                              _ userID: String,
                              completionHandler: @escaping (Result<[User]>) -> Void) {

    guard let url = preparationURL(path: UserPath.users + "\(userID)" + UserPath.following) else { return }

    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = self.checkResponse(response: response, completionHandler: completionHandler) else { return }

      guard self.checkBackendErrorStatus(httpResponse: httpResponse, completionHandler: completionHandler) else { return }

      guard let data = data else { return }

      do {
        let users = try self.decoder.decode([User].self, from: data)
        completionHandler(.success(users))
      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }

  /// Возвращает публикации пользователя с запрошенным ID.
  func getPostsWithUserID(_ token: String,
                          _ userID: String,
                          completionHandler: @escaping (Result<[Post]>) -> Void) {
    guard let url = preparationURL(path: UserPath.users + "\(userID)" + PostPath.posts) else { return }

    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = self.checkResponse(response: response, completionHandler: completionHandler) else { return }

      guard self.checkBackendErrorStatus(httpResponse: httpResponse, completionHandler: completionHandler) else { return }

      guard let data = data else { return }
      do {
        let posts = try self.decoder.decode([Post].self, from: data)
        completionHandler(.success(posts))
      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }

  /// Возвращает публикации пользователей, на которых подписан текущий пользователь.
  func getFeedPosts(_ token: String,
                    completionHandler: @escaping (Result<[Post]>) -> Void) {
    guard let url = preparationURL(path: PostPath.feed) else { return }

    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = self.checkResponse(response: response, completionHandler: completionHandler) else { return }

      guard self.checkBackendErrorStatus(httpResponse: httpResponse, completionHandler: completionHandler) else { return }

      guard let data = data else { return }
      do {
        let posts = try self.decoder.decode([Post].self, from: data)
        completionHandler(.success(posts))
      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }

  /// Возвращает публикацию с запрошенным ID.
  func getPostsWithID (_ token: String,
                       _ postsID: String,
                       completionHandler: @escaping (Result<Post>) -> Void) {
    guard let url = preparationURL(path: PostPath.posts + postsID) else { return }

    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = self.checkResponse(response: response, completionHandler: completionHandler) else { return }

      guard self.checkBackendErrorStatus(httpResponse: httpResponse, completionHandler: completionHandler) else { return }

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

  /// Возвращает пользователей, поставивших лайк на публикацию с запрошенным ID.
  func getLikePostUserWithPostID(_ token: String,
                                 _ postID: String,
                                 completionHandler: @escaping (Result<[User]>) -> Void) {
    guard let url = preparationURL(path: PostPath.posts + "\(postID)" + PostPath.likes) else { return }

    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = self.checkResponse(response: response, completionHandler: completionHandler) else { return }

      guard self.checkBackendErrorStatus(httpResponse: httpResponse, completionHandler: completionHandler) else { return }

      guard let data = data else { return }
      do {
        let users = try self.decoder.decode([User].self, from: data)
        completionHandler(.success(users))
      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }
}
