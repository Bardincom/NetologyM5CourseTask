//
//  NewPhotoProvider.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 02.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit
import Photos

class NewPhotoProvider {
    static let shared = NewPhotoProvider()

    private init() {}

    var fetchResult = PHFetchResult<PHAsset>()
    let imageManager = PHCachingImageManager()
    var previousPreheatRect = CGRect.zero

//    func resetCachedAssets() {
//        imageManager.stopCachingImagesForAllAssets()
//        previousPreheatRect = .zero
//    }

    func getImages() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
    }
}
