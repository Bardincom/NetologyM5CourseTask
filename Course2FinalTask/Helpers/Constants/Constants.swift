//
//  Constants.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 19.09.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit

public enum Model {
    static let name = "DataBase"
}

public enum SystemColors {
    static let backgroundColor = UIColor.systemBackground
    static let grayColor = UIColor.systemGray
    static let pinkColor = UIColor.systemPink
    static let redColor = UIColor.systemRed
}

public enum Constants {
    static let symbolWeight = UIImage.SymbolConfiguration(weight: .regular)
    static let cornerRadiusButton: CGFloat = 5
}

public enum Buttons {
    static let feed = UIImage(systemName: "house.fill", withConfiguration: Constants.symbolWeight)
    static let newPost = UIImage(systemName: "plus.app.fill", withConfiguration: Constants.symbolWeight)
    static let profile = UIImage(systemName: "person.fill", withConfiguration: Constants.symbolWeight)
    static let back = UIImage(systemName: "chevron.left", withConfiguration: Constants.symbolWeight)
    static let next = UIImage(systemName: "arrowshape.turn.up.right.fill", withConfiguration: Constants.symbolWeight)
    static let exit = UIImage(systemName: "multiply.circle", withConfiguration: Constants.symbolWeight)
    static let sharedPost = UIImage(systemName: "checkmark.circle.fill", withConfiguration: Constants.symbolWeight)
    static let camera = UIImage(systemName: "camera", withConfiguration: Constants.symbolWeight)
}
