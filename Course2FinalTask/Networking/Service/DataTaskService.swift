//
//  DataTaskService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

protocol DataTaskServiceProtocol {
    func dataTask<T: Codable>(with request: URLRequest, completionHandler: @escaping ResultBlock<T>)
}

class DataTaskService: DataTaskServiceProtocol {

    private let sharedSession = URLSession.shared
    private let decoder = JSONDecoder()
    private let dateFormatter: DateFormatter = .createdTime
    private let onlineService = CheckOnlineService.shared

    init() {
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

    /// Получение данных после запроса
    func dataTask<T: Codable>(with request: URLRequest, completionHandler: @escaping ResultBlock<T>) {
        let dataTask = sharedSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                self.onlineService.isOnline = false
                print("Возникла ошибка: \(error.localizedDescription)")
            }

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

    /// Проверка статуса запроса
    private func checkBackendErrorStatus<T>(httpResponse: HTTPURLResponse,
                                    completionHandler: @escaping ResultBlock<T>) -> Bool {
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

    /// Проверка ответа с сервера
    private func checkResponse<T>(response: URLResponse?,
                          completionHandler: @escaping ResultBlock<T>) -> HTTPURLResponse? {

        guard let httpResponse = response as? HTTPURLResponse else {

            let backendError = BackendError.transferError
            completionHandler(.failure(backendError))
            onlineService.isOnline = false
            ActivityIndicator.stop()
            return nil}
        onlineService.isOnline = true
        return httpResponse
    }
}
