//
//  ChooseUserTableViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/25/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

extension Array{
    subscript(path: NSIndexPath) -> T{
        return self[path.row]
    }
}

extension NSIndexPath{
    class func firstIndexPath() -> NSIndexPath{
        return NSIndexPath(forRow: 0, inSection: 0)
    }
}


class ChooseUserTableViewController: UITableViewController {
    struct TableViewValues{
        static let identifier = "CellUser"
    }
    
    /* This variable is defined as lazy so that its memory is allocated
    only when it is accessed for the first time. If we don't use this variable,
    no computation is done and no memory is allocated for this variable */
    let dataManager = DataManager()
    var cancelBarButtonItem: UIBarButtonItem!
    var selectionHandler: ((selectedItem: String) -> Void!)?
    var userID = 2
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tableView.registerClass(ChooseUserTableViewCell.classForCoder(),
            forCellReuseIdentifier: TableViewValues.identifier)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.getUserInfo()

    }
    func performCancel(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
           // let selectedItem = items[indexPath]
          //  selectionHandler?(selectedItem: selectedItem)
                                  userID = dataManager.userData[indexPath.row].userID
           self.performSegueWithIdentifier("returnHome", sender: self)

    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataManager.userData.count
        
    }

    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(
                TableViewValues.identifier, forIndexPath: indexPath) as! ChooseUserTableViewCell
            
            cell.name?.text = dataManager.userData[indexPath.row].userName as String
            
            return cell
            
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == "User"
        {
            println("1")
            if let inject = segue.destinationViewController as? InjectionBookAllViewController{
                println("2")
                if let injectIndex = tableView.indexPathForSelectedRow()?.row
                {
                    println("3")
                    inject.userID = dataManager.userData[injectIndex].userID
                }
            }
 
        }
    }
}
