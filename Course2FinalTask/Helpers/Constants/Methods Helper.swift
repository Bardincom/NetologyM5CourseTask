//
//  DataProvider Properties.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 11.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

func selectUsers(_ users: [User]?) -> [User] {
    guard let users = users else {
        return [User]()
    }
    return users
}
