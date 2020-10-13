//
//  BackendError.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

enum BackendError: Error, CustomStringConvertible {
    case badRequest // 400
    case unauthorized // 401
    case notFound // 404
    case notAcceptable // 406
    case unprocessable // 422 
    case transferError // other error

    var description: String {
        switch self {
            case .notFound: return Localization.Error.notFound
            case .badRequest: return Localization.Error.badRequest
            case .unauthorized: return Localization.Error.unauthorized
            case .notAcceptable: return Localization.Error.notAcceptable
            case .unprocessable: return Localization.Error.unprocessable
            case .transferError: return Localization.Error.offlineMode
        }
    }
}
