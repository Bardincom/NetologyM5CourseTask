//
//  UICollectionView + Extension.swift.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 01.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit
// swiftlint:disable force_cast
extension UICollectionView {

    func dequeue <T: UICollectionViewCell>(cell identifier: T.Type, for indexPath: IndexPath) -> T {
        let identifierString = String(describing: identifier)
        return dequeueReusableCell(withReuseIdentifier: identifierString, for: indexPath) as! T
    }

    func dequeue <T: UICollectionReusableView>(supplementaryView identifier: T.Type, kind: String, for indexPath: IndexPath) -> T {
        let identifierString = String(describing: identifier)
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifierString, for: indexPath) as! T
    }
}

extension UICollectionView {

    func register <T: UICollectionViewCell>(nibCell identifier: T.Type) {
        let identifierString = String(describing: identifier)
        let nib = UINib(nibName: identifierString, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifierString)
    }

    func register <T: UICollectionReusableView>(nibSupplementaryView identifier: T.Type, kind: String) {
        let identifierString = String(describing: identifier)
        let nib = UINib(nibName: identifierString, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifierString)
    }
}
