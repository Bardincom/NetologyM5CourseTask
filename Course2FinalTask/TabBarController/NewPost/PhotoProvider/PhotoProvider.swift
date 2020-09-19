//
//  PhotoProvider.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 13.07.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

struct PhotoProvider {
  var image: UIImage

  init(image: UIImage) {
    self.image = image
  }

  init?(dictionary: [String: String]) {
    guard
      let photo = dictionary["Photo"],
      let image = UIImage(named: photo)
      else {
        return nil
    }
    self.init(image: image)
  }

  static func allPhotos() -> [PhotoProvider] {
    var photos: [PhotoProvider] = []
    guard
      let URL = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
      let photosFromPlist = NSArray(contentsOf: URL) as? [[String: String]]
      else {
        return photos
    }
    for dictionary in photosFromPlist {
      if let photo = PhotoProvider(dictionary: dictionary) {
        photos.append(photo)
      }
    }
    return photos
  }
}
