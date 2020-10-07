//
//  Blocks.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

typealias ResultBlock<T> = (Result<T, BackendError>) -> Void
typealias UsersBlock = (Result<[User], BackendError>) -> Void
typealias PostsBlock = (Result<[Post], BackendError>) -> Void
typealias UserBlock = (Result<User, BackendError>) -> Void
typealias PostBlock = (Result<Post, BackendError>) -> Void
