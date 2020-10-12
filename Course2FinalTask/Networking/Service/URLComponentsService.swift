//
//  URLComponentsService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

protocol URLComponentsProtocol {
    func preparationURLComponents(path: String) -> URLComponents?
}

final class URLComponentsService: URLComponentsProtocol {

    private let scheme = "http"
    private let host = "localhost"
    private let port = 8080
    private let onlineService = CheckOnlineService.shared

    func preparationURLComponents(path: String) -> URLComponents? {
        guard onlineService.isOnline else { return nil }
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.port = port
        urlComponents.path = path
        return urlComponents
    }

}
