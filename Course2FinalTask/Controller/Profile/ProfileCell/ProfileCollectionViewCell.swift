//
//  ProfileCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 01.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit
import DataProvider

final class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var imageView: UIImageView!
    /// заполнение ячейки для заполнения постов
    func setImageCell(post: Post) {
        imageView.image = post.image
    }

    /// заполнение ячейки для отображение фотографий для публикации
    func imageView(newPhoto: UIImage) {
        imageView.image = newPhoto
    }
}
