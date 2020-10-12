//
//  ProfileCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 01.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit
//import Photos

final class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    /// заполнение ячейки для заполнения постов
    func setImageCell(post: Post) {
        imageView.kf.setImage(with: post.image)
    }

    func setImageCell(postOffline: PostOffline) {
        guard
            let postImage = postOffline.image,
            let image = UIImage(data: postImage)
        else {
            return
        }
        imageView.image = image
    }
}
