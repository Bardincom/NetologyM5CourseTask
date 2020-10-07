//
//  SessionProvider.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 05.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

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

//    enum HttpMethod {
//        static let get = "GET"
//        static let post = "POST"
//    }

    public var isOnline = true
    static var shared = SessionProvider()

    private init() {
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

}

// MARK: Helpers
extension SessionProvider {

    func preparationURLComponents(path: String) -> URLComponents? {
        guard isOnline else { return nil }
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.port = port
        urlComponents.path = path
        return urlComponents
    }

    func preparationURL(path: String) -> URL? {
        guard let url = preparationURLComponents(path: path)?.url else { return nil }
        return url
    }

    func preparationRequest(_ url: URL, _ httpMethod: String, _ token: String? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        defaultHeaders["token"] = token
        request.allHTTPHeaderFields = defaultHeaders
        return request
    }

    /// Проверка статуса запроса
    func checkBackendErrorStatus<T>(httpResponse: HTTPURLResponse,
                                    completionHandler: @escaping (Result<T, BackendError>) -> Void) -> Bool {
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

            completionHandler(.failure(backendError))
            ActivityIndicator.stop()
            return false
        }
        return true
    }

    func checkResponse<T>(response: URLResponse?,
                          completionHandler: @escaping (Result<T, BackendError>) -> Void) -> HTTPURLResponse? {

        guard let httpResponse = response as? HTTPURLResponse else {

            let backendError = BackendError.transferError
            completionHandler(.failure(backendError))
            isOnline = false
            ActivityIndicator.stop()
            return nil}
        isOnline = true
        return httpResponse
    }

    func dataTask<T: Codable>(with request: URLRequest, completionHandler: @escaping (Result<T, BackendError>) -> Void) {
        let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

            guard let httpResponse = self.checkResponse(response: response, completionHandler: completionHandler) else { return }
            guard self.checkBackendErrorStatus(httpResponse: httpResponse, completionHandler: completionHandler) else { return }
            guard let data = data else { return }

            do {
                let result = try self.decoder.decode(T.self, from: data)
                completionHandler(.success(result))
                ActivityIndicator.stop()
            } catch {
                completionHandler(.failure(.transferError))
                ActivityIndicator.stop()
            }
        }
        dataTask.resume()
    }
}
