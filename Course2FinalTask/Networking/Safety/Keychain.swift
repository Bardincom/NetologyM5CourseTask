//
//  Keychain.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 05.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

final class Keychain {

  private let service = "localhost"
  static let shared: Keychain = {
    let keychain = Keychain()
    return keychain
  }()

  private init() { }

  func saveToken(_ token: String) {
    let tokenData = token.data(using: .utf8)

    guard readToken() == nil else {
      var attributesToUpdate = [String: AnyObject]()
      attributesToUpdate[kSecValueData as String] = tokenData as AnyObject

      let query = keychainQuery()
      _ = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
      return
    }

    var item = keychainQuery()
    item[kSecValueData as String] = tokenData as AnyObject
    _ = SecItemAdd(item as CFDictionary, nil)
  }
}

private extension Keychain {

  func keychainQuery() -> [String: AnyObject] {
    var query = [String: AnyObject]()
    query[kSecClass as String] = kSecClassGenericPassword
    query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
    query[kSecAttrService as String] = service as AnyObject

    return query
  }
  
  func readToken() -> String? {
    var query = keychainQuery()
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    query[kSecReturnData as String] = kCFBooleanTrue
    query[kSecReturnAttributes as String] = kCFBooleanTrue

    let queryDictionary = query as CFDictionary
    var queryResult: CFTypeRef?
    let status = SecItemCopyMatching(queryDictionary, &queryResult)

    if status != noErr {
      return nil
    }

    guard let item = queryResult as? [String: AnyObject],
      let tokenData = item[kSecValueData as String] as? Data,
      let token = String(data: tokenData, encoding: .utf8) else { return nil }
    return token
  }

  func deleteToken() {
    let query = keychainQuery()
    _ = SecItemDelete(query as CFDictionary)
    //    return status == noErr
  }
}

