//
//  NewPostViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 26.04.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

final class NewPostViewController: UIViewController {

  let iPhoneAlbum = PhotoProvider.allPhotos()

  @IBOutlet private var newPostViewController: UICollectionView! {
    willSet {
      newValue.register(nibCell: ProfileCollectionViewCell.self)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = Names.newPost
    configureTitle()
  }
}

extension NewPostViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    iPhoneAlbum.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(cell: ProfileCollectionViewCell.self, for: indexPath)

    let photo = iPhoneAlbum[indexPath.row].image
    /// установка изображений
    cell.imageView(newPhoto: photo)
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
    let selectPhoto = iPhoneAlbum[indexPath.row].image

    let filtersViewController = FiltersViewController()

    filtersViewController.selectPhoto = selectPhoto
    self.navigationController?.pushViewController(filtersViewController, animated: true)
    newPostViewController.deselectItem(at: indexPath, animated: true)
  }

}
