//
//  CheckTokenService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

protocol CheckTokenProtocol {
    func checkToken(_ token: String, completionHandler: @escaping ResultBlock<Bool>)
}

class CheckTokenService: CheckTokenProtocol {

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

    /// Проверяет валидность токена.
    func checkToken(_ token: String,
                    completionHandler: @escaping ResultBlock<Bool>) {
        guard let url = urlService.preparationURL(path: TokenPath.check) else { return }
        let request = requestServise.preparationRequest(url, HttpMethod.get, token)

        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }
}