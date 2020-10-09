//
//  PhotoService.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 02.10.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol PhotoServiceProtocol {
    var fetchResult: PHFetchResult<PHAsset> { get set }
    func getImages()
    func getCountImage() -> Int
    func getFetchResult() -> PHFetchResult<PHAsset>
}

class PhotoService: PhotoServiceProtocol {

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
