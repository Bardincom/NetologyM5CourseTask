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

    var photoDataSource: PhotoServiceProtocol

    private let imageManager = PHCachingImageManager()
    private var thumbnailSize: CGSize?
    private var availableWidth: CGFloat = 0
    private var previousPreheatRect = CGRect.zero

    init(photoDataSource: PhotoServiceProtocol = PhotoService()) {
        self.photoDataSource = photoDataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet private var newPostViewController: UICollectionView! {
        willSet {
            newValue.register(nibCell: NewPostCollectionViewCell.self)
        }
    }

    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        resetCachedAssets()

        navigationItem.title = Localization.Names.newPost
        configureTitle()
        PHPhotoLibrary.shared().register(self)
        photoDataSource.getImages()
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let width = view.bounds.inset(by: view.safeAreaInsets).width
        // Adjust the item size if the available width has changed.
        if availableWidth != width {
            availableWidth = width
            let columnCount = (availableWidth / 80).rounded(.towardZero)
            let itemLength = (availableWidth - columnCount - 1) / columnCount
            collectionViewFlowLayout.itemSize = CGSize(width: itemLength, height: itemLength)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Определяет размер эскизов для запроса у PHCachingImageManager.
        let scale = UIScreen.main.scale
        let cellSize = collectionViewFlowLayout.itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
    }

    // MARK: UIScrollView

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }

    // MARK: Asset Caching

    private func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    /// - Tag: UpdateAssets
    private func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }

        // The window you prepare ahead of time is twice the height of the visible rect.
        let visibleRect = CGRect(origin: newPostViewController.contentOffset, size: newPostViewController.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)

        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }

        // Compute the assets to start and stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in newPostViewController.indexPathsForElements(in: rect) }
            .map { indexPath in photoDataSource.getFetchResult().object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in newPostViewController.indexPathsForElements(in: rect) }
            .map { indexPath in photoDataSource.getFetchResult().object(at: indexPath.item) }

        guard let thumbnailSize = thumbnailSize else { return }

        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        // Store the computed rectangle for future comparison.
        previousPreheatRect = preheatRect

    }

    private func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY, width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY, width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY, width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY, width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
}

extension NewPostViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataSource.getCountImage()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeue(cell: NewPostCollectionViewCell.self, for: indexPath)
        let asset = photoDataSource.getFetchResult().object(at: indexPath.item)
        guard let thumbnailSize = thumbnailSize else { return cell }
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil) { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        }

        return cell
    }
}

extension NewPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 1 }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let filtersViewController = FiltersViewController()
        let selectAsset = photoDataSource.getFetchResult().object(at: indexPath.item)

        filtersViewController.asset = selectAsset

        self.navigationController?.pushViewController(filtersViewController, animated: true)
        resetCachedAssets()
        newPostViewController.deselectItem(at: indexPath, animated: true)
    }
}

extension NewPostViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: photoDataSource.getFetchResult()) else { return }

        DispatchQueue.main.async {
            self.photoDataSource.fetchResult = changes.fetchResultAfterChanges

            guard changes.hasIncrementalChanges else {
                self.newPostViewController.reloadData()
                return }

            self.newPostViewController.performBatchUpdates {
                if let removed = changes.removedIndexes, !removed.isEmpty {
                    self.newPostViewController.deleteItems(at: removed.map { IndexPath(item: $0, section: 0) })
                }
                if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                    self.newPostViewController.insertItems(at: inserted.map { IndexPath(item: $0, section: 0) })
                }
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    self.newPostViewController.reloadItems(at: changed.map { IndexPath(item: $0, section: 0) })
                }

                changes.enumerateMoves { fromIndex, toIndex in
                    self.newPostViewController
                        .moveItem( at: IndexPath(item: fromIndex, section: 0),
                                   to: IndexPath(item: toIndex, section: 0))
                }
            }
            self.resetCachedAssets()
        }
    }
}
