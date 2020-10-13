//
//  AuthorizationService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

protocol AuthorizationProtocol {
    func signIn(login: String, password: String, completionHandler: @escaping ResultBlock<Token>)
    func signOut(_ token: String, completionHandler: @escaping ResultBlock<Bool>)
}

class AuthorizationService: AuthorizationProtocol {

    private let encoder = JSONEncoder()
    private let urlService: URLServiceProtocol
    private let requestService: RequestServiceProtocol
    private let dataProvider: DataTaskServiceProtocol

    init(urlService: URLServiceProtocol = URLService(),
         requestService: RequestServiceProtocol = RequestService(),
         dataProvider: DataTaskServiceProtocol = DataTaskService()) {
        self.urlService = urlService
        self.requestService = requestService
        self.dataProvider = dataProvider
    }

    /// Авторизует пользователя и выдает токен.
    func signIn(login: String,
                password: String,
                completionHandler: @escaping ResultBlock<Token>) {
        ActivityIndicator.start()

        guard let url = urlService.preparationURL(path: TokenPath.signIn) else { return }
        let authorization = Authorization(login: login, password: password)
        var request = requestService.preparationRequest(url, HttpMethod.post, nil)
        request.httpBody = try? encoder.encode(authorization)

        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }

    /// Деактивация пользователя и обнуление токен.
    func signOut(_ token: String, completionHandler: @escaping ResultBlock<Bool>) {
        guard let url = urlService.preparationURL(path: TokenPath.signOut) else { return }
        let request = requestService.preparationRequest(url, HttpMethod.post, token)

        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }
}
