//
//  URLService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 07.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

protocol URLServiceProtocol {
    func preparationURL(path: String) -> URL?
}

final class URLService: URLServiceProtocol {

    private let preparationURLComponents: URLComponentsProtocol

    init(preparationURLComponents: URLComponentsProtocol = URLComponentsService()) {
        self.preparationURLComponents = preparationURLComponents
    }

    func preparationURL(path: String) -> URL? {
        guard let url = preparationURLComponents.preparationURLComponents(path: path)?.url else { return nil }
        return url
    }
}
