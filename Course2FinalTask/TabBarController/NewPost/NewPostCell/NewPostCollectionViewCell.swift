//
//  NewPostCollectionViewCell.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 02.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

class NewPostCollectionViewCell: UICollectionViewCell {

    var representedAssetIdentifier: String?

    @IBOutlet var imageView: UIImageView!

    var thumbnailImage: UIImage? {
        didSet {
            imageView.image = thumbnailImage
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
