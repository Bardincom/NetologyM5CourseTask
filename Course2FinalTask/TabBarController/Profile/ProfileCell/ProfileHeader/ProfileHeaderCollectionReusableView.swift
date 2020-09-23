//
//  ProfileHeaderCollectionReusableView.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 01.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate: class {
  func openFollowersList()
  func openFollowingList()
  func followUnfollowUser()
}

final class ProfileHeaderCollectionReusableView: UICollectionReusableView {

  @IBOutlet private var avatarImage: UIImageView!
  @IBOutlet private var fullNameLabel: UILabel!
  @IBOutlet private var followersLabel: UILabel!
  @IBOutlet private var followingLabel: UILabel!
  @IBOutlet private var followButton: UIButton!

  var currentUser: User?
  private let session = SessionProvider.shared
  private let keychain = Keychain.shared

  weak var delegate: ProfileHeaderDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()
    guard let token = keychain.readToken() else { return }

    session.getCurrentUser(token) { [weak self] currentUser in
      guard let self = self else { return }
      switch currentUser {
        case .success(let currentUser):
          self.currentUser = currentUser
        case .fail( _):
          break
      }
    }

    followButton.layer.cornerRadius = 6
    setupTapGestureRecognizer()
  }

  func setHeader(user: User) {
    avatarImage.kf.setImage(with: user.avatar)
    avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
    fullNameLabel.alpha = 1
    fullNameLabel.font = systemsFont
    fullNameLabel.text = user.fullName
    followersLabel.alpha = 1
    followersLabel.font = systemsBoldFont
    followersLabel.text = "Followers: \(user.followedByCount)"
    followingLabel.alpha = 1
    followingLabel.font = systemsBoldFont
    followingLabel.text = "Following: \(user.followsCount)"

    buttonDisplay(user: user)

  }

  func buttonDisplay(user: User) {

    if user.currentUserFollowsThisUser {
      followButton.isHidden = false
      followButton.setTitle("Unfollow", for: .normal)
      followButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    } else {
      followButton.isHidden = false
      followButton.setTitle("Follow", for: .normal)
      followButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }

    if user.id == currentUser?.id {
      followButton.isHidden = true
    }
  }

  func setHeader(user: UserOffline) {
    avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
    fullNameLabel.alpha = 1
    fullNameLabel.font = systemsFont
    fullNameLabel.text = user.fullName
    followersLabel.alpha = 1
    followersLabel.font = systemsBoldFont
    followersLabel.text = "Followers: \(user.followedByCount)"
    followingLabel.alpha = 1
    followingLabel.font = systemsBoldFont
    followingLabel.text = "Following: \(user.followsCount)"

    guard
      let avatarData = user.avatar,
      let userAvatarImage = UIImage(data: avatarData) else { return }
    avatarImage.image = userAvatarImage

    buttonDisplay(user: user)

  }

  func buttonDisplay(user: UserOffline) {

    if user.currentUserFollowsThisUser {
      followButton.isHidden = false
      followButton.setTitle("Unfollow", for: .normal)
      followButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    } else {
      followButton.isHidden = false
      followButton.setTitle("Follow", for: .normal)
      followButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }

      followButton.isHidden = true
  }

}

// MARK: Selector
extension ProfileHeaderCollectionReusableView {

  @objc
  func followersTap() {
    delegate?.openFollowersList()
  }

  @objc
  func followingTap() {
    delegate?.openFollowingList()
  }

  @IBAction func followButtonAction(_ sender: UIButton) {
    delegate?.followUnfollowUser()
  }
}

// MARK: TapGestureRecognizer
private extension ProfileHeaderCollectionReusableView {
  func setupTapGestureRecognizer() {
    let gestureFollowersTap = UITapGestureRecognizer(target: self, action: #selector(followersTap))
    followersLabel.addGestureRecognizer(gestureFollowersTap)

    let gestureFollowingTap = UITapGestureRecognizer(target: self, action: #selector(followingTap))
    followingLabel.addGestureRecognizer(gestureFollowingTap)
  }
}
