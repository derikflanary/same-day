//
//  UserCell.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell, ReusableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarView: CircleAvatarView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with user: User) {
        nameLabel.text = user.name
        avatarView.update(user.name, avatarURL: nil)
    }

    func configure(with employee: Employee) {
        nameLabel.text = employee.displayName
        avatarView.update(employee.displayName, avatarURL: nil)
    }

}
