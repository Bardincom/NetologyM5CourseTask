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

final class SessionProvider {
  let sharedSession = URLSession.shared
  let decoder = JSONDecoder()
  let encoder = JSONEncoder()
  let dateFormatter: DateFormatter = .createdTime
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

  /// Проверка статуса запроса
  func checkBackendErrorStatus<T>(httpResponse: HTTPURLResponse,
                          completionHandler: @escaping (Result<T>) -> Void) {
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
  }

  func checkResponse<T>(response: URLResponse?,
                        completionHandler: @escaping (Result<T>) -> Void) -> HTTPURLResponse? {

    guard let httpResponse = response as? HTTPURLResponse else {

    let backendError = BackendError.transferError
    completionHandler(.fail(backendError))
    ActivityIndicator.stop()
    return nil}

    return httpResponse
  }

}
