//
//  ImageFilterOperation.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 12.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import Foundation
import UIKit

class ImageFilterOperation: Operation {

    private var _inputImage: UIImage?

    private(set) var outputImage: UIImage? {
        didSet {
            cancel()
        }
    }

    private var _chosenFilter: String?

    init(inputImage: UIImage?, filter: String) {
        self._chosenFilter = filter
        self._inputImage = inputImage
    }

    override func main() {
        guard !isCancelled else { return }

        guard let inputImage = _inputImage, let chosenFilter = _chosenFilter else { return }

        /// Создаем контекст
        let context = CIContext()

        // Создаем CIImage
        guard let coreImage = CIImage(image: inputImage) else { return }

        // Создаем фильтр
        guard let filter = CIFilter(name: chosenFilter) else { return }
        filter.setValue(coreImage, forKey: kCIInputImageKey)

        // Добавляем фильтр к изображению
        guard let filteredImage = filter.outputImage else { return }

        guard !isCancelled else { return }

        // Применяем фильтр
        guard let cgImage = context.createCGImage(filteredImage,
                                                  from: filteredImage.extent) else { return }

        /// результат фильтрайии
        outputImage = UIImage(cgImage: cgImage)

    }
}
