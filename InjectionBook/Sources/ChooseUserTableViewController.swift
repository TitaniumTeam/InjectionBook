//
//  ChooseUserTableViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/25/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit




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
    var chooseRow = 0

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
            chooseRow = indexPath.row
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
            
            if dataManager.userData[indexPath.row].gender == 0
            {
                cell.avartar.image = UIImage(named: "avatar_icon_girl")
            }
            
            cell.name?.text = dataManager.userData[indexPath.row].userName as String
            
            return cell
            
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == "User"
        {
       println("tét//")
            if let inject = segue.destinationViewController as? InjectionBookAllViewController{
              
                if let injectIndex = tableView.indexPathForSelectedRow()?.row
                {
                  
                    inject.userID = dataManager.userData[injectIndex].userID
                }
            }
 
        }
    }
}
