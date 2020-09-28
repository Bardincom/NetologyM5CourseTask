//
//  UIImage + Extension.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 12.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

//https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift

extension UIImage {
    /// Изменяет фотографию до размера 50x50 px
    public func resizedImage() -> UIImage? {
        let newSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
