//
//  FiltersViewController.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 11.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit
import Photos

final class FiltersViewController: UIViewController {

    public var asset: PHAsset?
    private var filterPhoto: UIImage?
    private let filters = Filters().filterArray
    private let operationQueue = OperationQueue()
    private var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: bigImage.bounds.width * scale, height: bigImage.bounds.height * scale)
    }

    @IBOutlet var bigImage: UIImageView!
    @IBOutlet private var filterViewController: UICollectionView! {
        willSet {
            newValue.register(nibCell: FiltersCollectionViewCell.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupFiltersViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateStaticImage()
    }
}

extension FiltersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: FiltersCollectionViewCell.self, for: indexPath)

        guard let thumbnailPhotos = filterPhoto else { return cell }
        let filterName = filters[indexPath.row]

        cell.setFilter(filterName, for: thumbnailPhotos)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ActivityIndicator.start()
        let selectFilter = filters[indexPath.row]

        let applyFilter = ImageFilterOperation(inputImage: filterPhoto, filter: selectFilter)

        applyFilter.completionBlock = { [weak self] in
            guard let self = self else { return }

            OperationQueue.main.addOperation {
                self.bigImage.image = applyFilter.outputImage
                ActivityIndicator.stop()
            }
        }

        operationQueue.addOperation(applyFilter)
    }
}

private extension FiltersViewController {

    func setupFiltersViewController() {
        let nextButton = UIBarButtonItem(image: Buttons.next,
                                         style: .plain,
                                         target: self,
                                         action: #selector(pressNextButton(_:)))
        nextButton.tintColor = Asset.ColorAssets.appearance.color
        navigationItem.rightBarButtonItem = .some(nextButton)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        bigImage.image = filterPhoto
        title = Names.filters
    }

    @objc
    func pressNextButton(_ sender: UITapGestureRecognizer) {
        let descriptionScreenViewController = DescriptionScreenViewController()
        guard let publishedPhoto = bigImage.image else { return }
        descriptionScreenViewController.newPublishedPhoto = publishedPhoto
        self.navigationController?.pushViewController(descriptionScreenViewController, animated: true)
    }

    func updateStaticImage() {
        guard let asset = asset else { return }

        PHImageManager.default().requestImage(for: asset,
                                              targetSize: targetSize,
                                              contentMode: .aspectFill,
                                              options: nil,
                                              resultHandler: { image, _ in
                                                guard let image = image else { return }
                                                self.bigImage.image = image
                                                self.filterPhoto = image
        })
    }
}
