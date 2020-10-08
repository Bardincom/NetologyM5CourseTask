//
//  NetworkService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

final class NetworkService {

    private let authorizationServise: AuthorizationProtocol
    private let checkTokenService: CheckTokenProtocol
    private let getService: GETProtocol
    private let postService: POSTProtocol

    init(authorizationServise: AuthorizationProtocol = AuthorizationService(),
         checkTokenService: CheckTokenProtocol = CheckTokenService(),
         getService: GETProtocol = GETService(),
         postService: POSTProtocol = POSTService()) {
        self.authorizationServise = authorizationServise
        self.checkTokenService = checkTokenService
        self.getService = getService
        self.postService = postService
    }

    func authorization() -> AuthorizationProtocol {
        return authorizationServise
    }

    func checkToken() -> CheckTokenProtocol {
        return checkTokenService
    }

    func getRequest() -> GETProtocol {
        return getService
    }

    func postRequest() -> POSTProtocol {
        return postService
    }
}
