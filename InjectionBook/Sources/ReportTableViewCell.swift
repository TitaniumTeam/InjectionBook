//
//  ReportTableViewCell.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/20/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var sickCode: UILabel!
    @IBOutlet weak var injectView: UIView!
    var injectBtn: [UIButton] = []
    var sickID = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
