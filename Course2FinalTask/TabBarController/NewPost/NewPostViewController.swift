//
//  NewPostViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 26.04.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit
import Photos

final class NewPostViewController: UIViewController {

    var assetCollection = [PHAsset]()
//    var photos : PHFetchResult<PHAsset>?

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
        assetCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: ProfileCollectionViewCell.self, for: indexPath)

        let asset = self.assetCollection[indexPath.row]
        let manager = PHImageManager.default()

        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: nil) { (image, _) in
            DispatchQueue.main.async {
                guard let image = image else { return }
                cell.imageView(newPhoto: image)
            }
        }

        return cell
    }
}

extension NewPostViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = newPostViewController.bounds.width / 3
        return CGSize(width: size, height: size)
    }

    /// убираю отступ между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 0 }

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

                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
                assets.enumerateObjects { (object, _, _) in
                    self.assetCollection.append(object)
                }

                DispatchQueue.main.async {
                    self.newPostViewController.reloadData()
                }
        }

    }
}

//extension NewPostViewController: PHPhotoLibraryChangeObserver {
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        guard let newPostViewController = newPostViewController else { return }
//        guard let photos = photos else {return}
//
//        DispatchQueue.main.async {
//            if let albumChanges = changeInstance.changeDetails(for: photos) {
//
//            }
//        }
//    }
//
//
//}
