//
//  InjectionBookTableViewCell.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/20/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class InjectionBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sickName: UILabel!
    @IBOutlet weak var dayInjection: UILabel!
    @IBOutlet weak var numberInjection: UILabel!
    @IBOutlet weak var iconInj: UIImageView!
    @IBOutlet weak var isInjectImg: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
