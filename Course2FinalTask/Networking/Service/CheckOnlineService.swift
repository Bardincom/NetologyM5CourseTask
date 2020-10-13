//
//  CheckOnlineServise.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

final class CheckOnlineService {
    static let shared = CheckOnlineService()
    var isOnline = true
    private init() {}

}
