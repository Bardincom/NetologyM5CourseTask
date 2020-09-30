//
//  NewPostViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 26.04.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//  swiftlint:disable empty_count

import UIKit
import Photos

final class NewPostViewController: UIViewController {

    var assetsFetchResult = PHFetchResult<PHAsset>()

    @IBOutlet private var newPostViewController: UICollectionView! {
        willSet {
            newValue.register(nibCell: ProfileCollectionViewCell.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Names.newPost
        configureTitle()
        getImages()
    }

}

extension NewPostViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsFetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: ProfileCollectionViewCell.self, for: indexPath)

        let asset = self.assetsFetchResult[indexPath.row]
        let manager = PHImageManager.default()

        manager.requestImage(for: asset, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFit, options: nil) { (image, _) in
            DispatchQueue.main.async {
                guard let image = image else { return }
                cell.imageView(newPhoto: image)
            }
        }

        return cell
    }
}

extension NewPostViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 1 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (newPostViewController.bounds.width - 1) / 3
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let selectPhoto = iPhoneAlbum[indexPath.row].image
        //
        //        let filtersViewController = FiltersViewController()
        //
        //        filtersViewController.selectPhoto = selectPhoto
        //        self.navigationController?.pushViewController(filtersViewController, animated: true)
        //        newPostViewController.deselectItem(at: indexPath, animated: true)
    }
}

extension NewPostViewController {
    func getImages() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }

            guard status == .authorized else { return }
            let options = PHFetchOptions()

            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            let photoFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
                if photoFetchResult.count > 0 {
                    let album = photoFetchResult[0]
                    self.assetsFetchResult = PHAsset.fetchAssets(in: album, options: options)
                    PHPhotoLibrary.shared().register(self)
                }

            DispatchQueue.main.async {
                self.newPostViewController.reloadData()
            }
        }
    }
}

extension NewPostViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: assetsFetchResult) else {
            DispatchQueue.main.async {
                self.newPostViewController.reloadData()
            }
            return }

        DispatchQueue.main.async {
            self.assetsFetchResult = changes.fetchResultAfterChanges

            guard changes.hasIncrementalChanges else { return }

            self.newPostViewController.performBatchUpdates {
                if let removed = changes.removedIndexes, !removed.isEmpty {
                    self.newPostViewController.deleteItems(at: removed.map { IndexPath(item: $0, section: 0) })
                }
                if let inserted = changes.removedIndexes, !inserted.isEmpty {
                    self.newPostViewController.insertItems(at: inserted.map { IndexPath(item: $0, section: 0) })
                }
                if let changed = changes.removedIndexes, !changed.isEmpty {
                    self.newPostViewController.reloadItems(at: changed.map { IndexPath(item: $0, section: 0) })
                }

                changes.enumerateMoves { fromIndex, toIndex in
                    self.newPostViewController
                        .moveItem( at: IndexPath(item: fromIndex, section: 0),
                                   to: IndexPath(item: toIndex, section: 0))
                }
            }
        }
    }
}
