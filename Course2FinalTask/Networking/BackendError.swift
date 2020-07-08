//
//  BackendError.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

enum BackendError: Error, CustomStringConvertible {
  case notFound
  case badRequest
  case unauthorized
  case notAcceptable
  case unprocessable
  case transferError

  var description: String {
    switch self {
      case .notFound: return "Not found"
      case .badRequest: return "Bad request"
      case .unauthorized: return "Unauthorized"
      case .notAcceptable: return "Not acceptable"
      case .unprocessable: return "Unprocessable"
      case .transferError: return "Transfer error"
    }
  }
}
