//
//  UserListTableViewCell.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 07.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

protocol UserListTableViewCellDelegate: class {
    func followUnfollowUser(cell: UserListTableViewCell)
}

final class UserListTableViewCell: UITableViewCell {

    @IBOutlet private var avatarImage: UIImageView!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet var followButton: UIButton!

    var currentUser: User?
//    private let session = SessionProvider.shared
    private let networkService = NetworkService()
    private let keychain = Keychain.shared

    weak var delegate: UserListTableViewCellDelegate?

    @IBAction func followButtonAction(_ sender: UIButton) {
        delegate?.followUnfollowUser(cell: self)
    }

    func setupList(user: User) {
        avatarImage.kf.setImage(with: user.avatar)
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        userNameLabel.text = user.username

        self.buttonDisplay(user: user)
    }

    func buttonDisplay(user: User) {
        followButton.layer.cornerRadius = 6

        if user.currentUserFollowsThisUser {
            self.followButton.isHidden = false
            self.followButton.setTitle(Names.unfollow, for: .normal)
            self.followButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        } else {
            self.followButton.isHidden = false
            self.followButton.setTitle(Names.follow, for: .normal)
            self.followButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        }

        guard let token = keychain.readToken() else { return }

        networkService.getRequest().getCurrentUser(token) { [weak self] currentUser in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch currentUser {
                    case .success(let currentUser):
                        self.currentUser = currentUser
                        if user.id == currentUser.id {
                            self.followButton.isHidden = true
                    }
                    case .failure( _):
                        break
                }
            }
        }
    }
}
