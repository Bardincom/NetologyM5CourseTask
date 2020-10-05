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

class PhotoProvider: PhotoDataSourse {

    var fetchResult = PHFetchResult<PHAsset>()

    func getImages() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
    }

    func getCountImage() -> Int {
        fetchResult.count
    }

    func getFetchResult() -> PHFetchResult<PHAsset> {
        fetchResult
    }

}
