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
  func checkToken(_ token: String, completionHandler: @escaping (Result<Bool>) -> Void) {
    guard let url = preparationURL(path: TokenPath.check) else { return }

    let request = preparationRequest(url, HttpMethod.get, token)

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in
      guard let httpResponse = response as? HTTPURLResponse else {
        let backendError = BackendError.transferError
        ActivityIndicator.stop()
        completionHandler(.fail(backendError))
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

      completionHandler(.success(true))
    }

    dataTask.resume()
  }

  /// Возвращает информацию о текущем пользователе.
  func getCurrentUser(_ token: String, completionHandler: @escaping (Result<User1>) -> Void) {
    guard let url = preparationURL(path: UserPath.currentUser) else { return }

    let request = preparationRequest(url, HttpMethod.get, token)

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
        let currentUser = try self.decoder.decode(User1.self, from: data)
        completionHandler(.success(currentUser))
        ActivityIndicator.stop()
      } catch {
        completionHandler(.fail(BackendError.unauthorized))
      }
    }

    dataTask.resume()
  }

  /// Возвращает информацию о пользователе с запрошенным ID.
  func getUserWithID (_ token: String, _ userID: String, completionHandler: @escaping (Result<User1>) -> Void) {
    guard let url = preparationURL(path: UserPath.usersSlash + userID) else { return }
    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    print(defaultHeaders)
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
      print("Data \(data)")
      do {
        let user = try self.decoder.decode(User1.self, from: data)
        completionHandler(.success(user))
        print(user)

      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }

  /// Возвращает подписчиков пользователя с запрошенным ID
  func getFollowersWithUserID(_ token: String, _ userID: String, completionHandler: @escaping (Result<[User1]>) -> Void) {
    guard let url = preparationURL(path: UserPath.usersSlash + "\(userID)" + UserPath.followers) else { return }
    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    print(defaultHeaders)
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
      print("Data \(data)")
      do {
        let users = try self.decoder.decode([User1].self, from: data)
        completionHandler(.success(users))
        print(users)

      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }

  /// Возвращает подписки пользователя с запрошенным ID
  func getFollowingWithUserID(_ token: String, _ userID: String, completionHandler: @escaping (Result<[User1]>) -> Void) {
    guard let url = preparationURL(path: UserPath.usersSlash + "\(userID)" + UserPath.following) else { return }
    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    print(defaultHeaders)
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
      print("Data \(data)")
      do {
        let users = try self.decoder.decode([User1].self, from: data)
        completionHandler(.success(users))
        print(users)

      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }

  /// Возвращает публикации пользователя с запрошенным ID.
  func getPostsWithUserID(_ token: String, _ userID: String, completionHandler: @escaping (Result<[Post1]>) -> Void) {
    guard let url = preparationURL(path: UserPath.usersSlash + "\(userID)" + UserPath.following) else { return }
    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    print(defaultHeaders)
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
      print("Data \(data)")
      do {
        let posts = try self.decoder.decode([Post1].self, from: data)
        completionHandler(.success(posts))
        print(posts)

      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }

  /// Возвращает публикации пользователей, на которых подписан текущий пользователь.
  func getFeedPostsWithUserID(_ token: String, completionHandler: @escaping (Result<[Post1]>) -> Void) {
    guard let url = preparationURL(path: PostPath.feed) else { return }
    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    print(defaultHeaders)
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
      print("Data \(data)")
      do {
        let posts = try self.decoder.decode([Post1].self, from: data)
        completionHandler(.success(posts))
        print(posts)

      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }

  /// Возвращает публикации пользователей, на которых подписан текущий пользователь.
  func getPostsWithID (_ token: String, _ postsID: String, completionHandler: @escaping (Result<Post1>) -> Void) {
    guard let url = preparationURL(path: PostPath.postsSlash + postsID) else { return }
    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    print(defaultHeaders)
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
      print("Data \(data)")
      do {
        let post = try self.decoder.decode(Post1.self, from: data)
        completionHandler(.success(post))
        print(post)

      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }

  /// Возвращает пользователей, поставивших лайк на публикацию с запрошенным ID.
  func getLikePostUserWithPostID(_ token: String, _ postID: String, completionHandler: @escaping (Result<[Post1]>) -> Void) {
    guard let url = preparationURL(path: PostPath.postsSlash + "\(postID)" + PostPath.likes) else { return }
    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    print(defaultHeaders)
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
      print("Data \(data)")
      do {
        let posts = try self.decoder.decode([Post1].self, from: data)
        completionHandler(.success(posts))
        print(posts)

      } catch {
        completionHandler(.fail(BackendError.transferError))
      }
    }

    dataTask.resume()
  }
}
