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
      case .notFound: return "Not found"
      case .badRequest: return "Bad request"
      case .unauthorized: return "Unauthorized"
      case .notAcceptable: return "Not acceptable"
      case .unprocessable: return "Unprocessable"
      case .transferError: return "Offline mode"
    }
  }
}
