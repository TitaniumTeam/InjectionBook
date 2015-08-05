//
//  TabBarViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/22/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
   
    override func awakeFromNib() {
        self.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
