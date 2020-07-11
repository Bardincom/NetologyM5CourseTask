//
//  SessionProvider.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 05.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

enum Result<T> {
  case success(T)
  case fail(BackendError)
}

class SessionProvider {
  let sharedSession = URLSession.shared
  let decoder = JSONDecoder()
  let dateFormatter: DateFormatter = .createdTime
  let encoder = JSONEncoder()
  let scheme = "http"
  let host = "localhost"
  let port = 8080
  var defaultHeaders =
    [
      "Content-Type": "application/json",
      "token": ""
    ]

  enum HttpMethod {
    static let get = "GET"
    static let post = "POST"
  }

  static var shared = SessionProvider()

  private init() {
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
  }

}

// MARK: Helpers
extension SessionProvider {

  func preparationURLComponents(path: String) -> URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = host
    urlComponents.port = port
    urlComponents.path = path
    print(urlComponents)
    return urlComponents
  }

  func preparationURL(path: String) -> URL? {
    guard let url = preparationURLComponents(path: path).url else { return nil }
    return url
  }

  func preparationRequest(_ url: URL, _ httpMethod: String, _ token: String) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    defaultHeaders["token"] = token
    request.allHTTPHeaderFields = defaultHeaders

    return request
  }
}
