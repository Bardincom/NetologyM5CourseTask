//
//  Blocks.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

typealias ResultBlock<T> = (Result<T, BackendError>) -> Void
typealias Block<T> = (T) -> Void
