//
//  AuthorisationService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

protocol AuthorizationProtocol {
    func signin(login: String, password: String, completionHandler: @escaping ResultBlock<Token>)
    func signout(_ token: String, completionHandler: @escaping ResultBlock<Bool>)
}

class AuthorizationService: AuthorizationProtocol {

    private let encoder = JSONEncoder()
    private let urlService: URLServiceProtocol
    private let requestServise: RequestServiceProtocol
    private let dataProvider: DataProviderProtocol

    init(urlService: URLServiceProtocol = URLService(),
         requestServise: RequestServiceProtocol = RequestService(),
         dataProvider: DataProviderProtocol = DataProvider()) {
        self.urlService = urlService
        self.requestServise = requestServise
        self.dataProvider = dataProvider
    }

    /// Авторизует пользователя и выдает токен.
    func signin(login: String,
                password: String,
                completionHandler: @escaping ResultBlock<Token>) {
        ActivityIndicator.start()

        guard let url = urlService.preparationURL(path: TokenPath.signin) else { return }
        let authorization = Authorization(login: login, password: password)
        var request = requestServise.preparationRequest(url, HttpMethod.post, nil)
        request.httpBody = try? encoder.encode(authorization)

        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Деавторизует пользователя и инвалидирует токен.
    func signout(_ token: String, completionHandler: @escaping ResultBlock<Bool>) {
        guard let url = urlService.preparationURL(path: TokenPath.signout) else { return }
        let request = requestServise.preparationRequest(url, HttpMethod.post, token)

        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }
}
