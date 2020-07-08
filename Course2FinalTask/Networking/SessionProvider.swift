//
//  SessionProvider.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 05.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit

enum Result<T> {
  case success(T)
  case fail(BackendError)
}

class SessionProvider {
  private let sharedSession = URLSession.shared
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  private let scheme = "http"
  private let host = "localhost"
  private let port = 8080
  private let httpMethod = "POST"
  private var defaultHeaders =
    [
      "Content-Type": "application/json",
      "token": ""
    ]

  private func preparationURLComponents(path: String) -> URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = host
    urlComponents.port = port
    urlComponents.path = path
    print(urlComponents)
    return urlComponents
  }

  private func preparationURL(path: String) -> URL? {
    guard let url = preparationURLComponents(path: path).url else { return nil }
    return url
  }
}

// MARK: POST
extension SessionProvider {

  func signin(login: String, password: String, completionHandler: @escaping (Result<Token>) -> Void) {
    ActivityIndicator.start()
    guard let url = preparationURL(path: TokenPath.signin) else { return }

    var request = URLRequest(url: url)
    request.httpMethod = httpMethod

    let json = "{\"login\" : \"\(login)\", \"password\" : \"\(password)\"}"
    request.httpBody = json.data(using: .utf8)
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      guard let httpResponse = response as? HTTPURLResponse else {

        let backendError = BackendError.transferError
        ActivityIndicator.stop()
        completionHandler(.fail(backendError))
        return }

      switch httpResponse.statusCode {
        case 422:
          let backendError = BackendError.unprocessable
          ActivityIndicator.stop()
          completionHandler(.fail(backendError))
          return
        default:
          print("http status code: \(httpResponse.statusCode)")
          break
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

  func signout(_ token: String) {
    guard let url = preparationURL(path: TokenPath.signout) else { return }

    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request)
    dataTask.resume()
  }
}

// MARK: GET
extension SessionProvider {
  func checkToken(_ token: String) {
    guard let url = preparationURL(path: TokenPath.check) else { return }

    var request = URLRequest(url: url)
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in
      guard let httpResponse = response as? HTTPURLResponse else { return }

      switch httpResponse.statusCode {
        case 200:
          print("http status code: \(httpResponse.statusCode)")
          return
        default:
          print("http status code: \(httpResponse.statusCode)")
          break
      }
    }

    dataTask.resume()
  }

  func getCurrentUser(_ token: String) {
    guard let url = preparationURL(path: UserPath.currentUser) else { return }

    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: request) { (data, responce, error) in
      print("data")
    }

    dataTask.resume()
  }
}
