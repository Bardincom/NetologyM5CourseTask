//
//  RequestServise.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

protocol RequestServiceProtocol {
    func preparationRequest(_ url: URL, _ httpMethod: String, _ token: String?) -> URLRequest
}

final class RequestService: RequestServiceProtocol {

    var defaultHeaders =
        [
            "Content-Type": "application/json",
            "token": ""
        ]

    func preparationRequest(_ url: URL, _ httpMethod: String, _ token: String? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        defaultHeaders["token"] = token
        request.allHTTPHeaderFields = defaultHeaders
        return request
    }
}
