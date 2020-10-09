//
//  Filters.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 12.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation

struct Filters {

    let filterArray = [
        Filter.ciColorClamp,
        Filter.ciBoxBlur,
        Filter.ciColorInvert,
        Filter.ciPhotoEffectNoir,
        Filter.ciSpotColor,
        Filter.ciPhotoEffectTonal,
        Filter.ciPixellate,
        Filter.ciSepiaTone
    ]

    enum Filter: String {
        case ciColorClamp = "CIColorClamp"
        case ciBoxBlur = "CIBoxBlur"
        case ciColorInvert = "CIColorInvert"
        case ciPhotoEffectNoir = "CIPhotoEffectNoir"
        case ciSpotColor = "CISpotColor"
        case ciPhotoEffectTonal = "CIPhotoEffectTonal"
        case ciPixellate = "CIPixellate"
        case ciSepiaTone = "CISepiaTone"

        var description: String {
            switch self {
                case .ciColorClamp: return "Normal"
                case .ciBoxBlur: return "BoxBlur"
                case .ciColorInvert: return "ColorInvert"
                case .ciPhotoEffectNoir: return "Noir"
                case .ciSpotColor: return "SpotColor"
                case .ciPhotoEffectTonal: return "Tonal"
                case .ciPixellate: return "Pixellate"
                case .ciSepiaTone: return "Sepia"
            }
        }
    }
}
