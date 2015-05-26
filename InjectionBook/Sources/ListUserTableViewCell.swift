//
//  ListUserTableViewCell.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/16/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class ListUserTableViewCell: UITableViewCell {


    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var avatarUser: UIImageView!
    @IBOutlet weak var birthDayUser: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarUser.layer.borderWidth = 1
        avatarUser.layer.masksToBounds = false
        avatarUser.layer.borderColor = UIColor.grayColor().CGColor
        avatarUser.layer.cornerRadius = avatarUser.frame.height/2
        avatarUser.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
