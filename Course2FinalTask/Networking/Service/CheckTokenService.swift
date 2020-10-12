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
    private let requestService: RequestServiceProtocol
    private let dataProvider: DataTaskServiceProtocol

    init(urlService: URLServiceProtocol = URLService(),
         requestService: RequestServiceProtocol = RequestService(),
         dataProvider: DataTaskServiceProtocol = DataTaskService()) {
        self.urlService = urlService
        self.requestService = requestService
        self.dataProvider = dataProvider
    }

    /// Проверяет валидность токена.
    func checkToken(_ token: String,
                    completionHandler: @escaping ResultBlock<Bool>) {
        guard let url = urlService.preparationURL(path: TokenPath.check) else { return }
        let request = requestService.preparationRequest(url, HttpMethod.get, token)

        dataProvider.dataTask(with: request, completionHandler: completionHandler)
    }
}
