//
//  DetailCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 25.02.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit
import DataProvider

protocol FeedCollectionViewProtocol: class {
    func openUserProfile(cell: FeedCollectionViewCell)
    func likePost(cell: FeedCollectionViewCell)
    func userList(cell: FeedCollectionViewCell)
}

final class FeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet var likeButton: UIButton!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var likesLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var containerStackView: UIStackView!
    @IBOutlet var feedActivityIndicatorView: UIActivityIndicatorView!

    @IBOutlet private var bigLike: UIImageView!

    @IBOutlet private var cellConstraintsWidthConstraint: NSLayoutConstraint! {
        willSet {
            newValue.constant = UIScreen.main.bounds.width
        }
    }

    weak var delegate: FeedCollectionViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupFonts()
        setupTapGestureRecognizer()

    }

    /// настройка ленты
    func setupFeed(post: Post) {
        dateLabel.text = post.createdTime.displayDate()
        avatarImageView.image = post.authorAvatar
        userNameLabel.text = post.authorUsername
        imageView.image = post.image
        likesLabel.text = "Likes: " + "\(post.likedByCount)"
        descriptionLabel.text = post.description

        /// отображение лайка на публикации текущего пользователя
        guard post.currentUserLikesThisPost else {
            likeButton.tintColor = Asset.ColorAssets.lightGray.color
            return
        }
        likeButton.tintColor = Asset.ColorAssets.defaultTint.color
    }

}

// MARK: Selector
extension FeedCollectionViewCell {

    @objc
    private func goToProfile() {
        delegate?.openUserProfile(cell: self)
    }

    @objc
    private func likeTap() {
        delegate?.likePost(cell: self)
    }

    @objc
    private func openLikeList() {
        delegate?.userList(cell: self)
    }

    @objc
    private func doudleLikeTap() {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.curveLinear],
                       animations: {
            self.bigLike.alpha = 1.0
        }, completion: {_ in
            UIView.animate(withDuration: 0.3,
                           delay: 0.2,
                           options: [.curveEaseOut],
                           animations: {
                self.bigLike.alpha = 0
            }, completion: nil)
        })

        if likeButton.tintColor == Asset.ColorAssets.lightGray.color {
            delegate?.likePost(cell: self)
        }
    }
}

// MARK: FeedCollectionViewCell Helper
private extension FeedCollectionViewCell {

    func setupFonts() {
        dateLabel.font = systemsFont
        userNameLabel.font = systemsBoldFont
        likesLabel.font = systemsBoldFont
        descriptionLabel.font = systemsFont
        likeButton.tintColor = Asset.ColorAssets.defaultTint.color
    }
}

// MARK: TapGestureRecognizer
private extension FeedCollectionViewCell {
    func setupTapGestureRecognizer() {
        /// жест по картинке для лайка
        let gestureImageTap = UITapGestureRecognizer(target: self, action: #selector(doudleLikeTap))
        gestureImageTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(gestureImageTap)

        /// жест кнопке лайк
        let gestureLikeButtonTap = UITapGestureRecognizer(target: self, action: #selector(likeTap))
        likeButton.addGestureRecognizer(gestureLikeButtonTap)

        /// жест для перехода по аватару
        let gestureAvatarTap = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        avatarImageView.addGestureRecognizer(gestureAvatarTap)

        /// жест для перехода по имени и дате(использовал SteakView)
        let gestureNameTap = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        containerStackView.addGestureRecognizer(gestureNameTap)

        /// жест по надписи количество лайков
        let gestureLikeLabelTap = UITapGestureRecognizer(target: self, action: #selector(openLikeList))
        likesLabel.addGestureRecognizer(gestureLikeLabelTap)
    }
}
