//
//  FiltersCollectionViewCell.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 11.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class FiltersCollectionViewCell: UICollectionViewCell {

    @IBOutlet var thumbnailPhoto: UIImageView!
    @IBOutlet var filterNameLabel: UILabel!

    func setFilter(_ name: Filters.Filter, for photo: UIImage) {
        let operationQueue = OperationQueue()

        self.filterNameLabel.text = name.description
        let filterOperation = ImageFilterOperation(inputImage: photo, filter: name)

        filterOperation.completionBlock = { [ weak self] in
            guard let self = self else { return }

            OperationQueue.main.addOperation {
                self.thumbnailPhoto.image = photo.resizedImage()
                self.thumbnailPhoto.image = filterOperation.outputImage
            }
        }
        operationQueue.addOperation((filterOperation))
    }
}
