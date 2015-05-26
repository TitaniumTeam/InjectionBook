//
//  ChooseVaccineViewCell.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/21/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class ChooseVaccineViewCell: UITableViewCell {

    @IBOutlet weak var sickName: UILabel!
    @IBOutlet weak var isCheck: UIImageView!
    var intSelected = 0
    var sickID = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
