//
//  SidePanelViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/25/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

@objc
protocol SidePanelViewControllerDelegate {
    func userSelected(user: UserInfo)
}

class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataManager = DataManager()
    var delegate: SidePanelViewControllerDelegate?
    
  //  var animals: Array<Animal>!
    
    struct TableView {
        struct CellIdentifiers {
            static let UserCell = "UserCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.getUserInfo()
        tableView.reloadData()
    }
    
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.userData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.UserCell, forIndexPath: indexPath) as! ListChooseTableViewCell
        cell.configureForUser(dataManager.userData[indexPath.row])
        return cell
    }
    
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedUser = dataManager.userData[indexPath.row]
        delegate?.userSelected(selectedUser)
    }
    



}