//
//  ListUserTableViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/16/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class ListUserTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource
 {

    
    @IBOutlet var tableListUser: UITableView!
    let dataManager = DataManager()

    var rowForEdit = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dataManager.userData.count == 0
        {
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableListUser.scrollsToTop = true
        dataManager.getUserInfo()
        tableListUser.reloadData()
        self.navigationItem.title = "Danh sách bé"
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.greenColor()
        dataManager.getUserInfo()
        tableListUser.reloadData()
        
        if dataManager.userData.count == 0
        {
            self.performSegueWithIdentifier("AddFirtUser", sender: nil)
        }
        tableListUser.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
        var navController: UINavigationController = self.tabBarController?.viewControllers?[0] as! UINavigationController
        
        var listUser = navController.viewControllers[0] as!ListUserTableViewController
        //    [search initWithText:@"This is a test"];
        self.tabBarController!.selectedViewController = navController
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataManager.userData.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListUserCell", forIndexPath: indexPath) as! ListUserTableViewCell
        
        cell.nameUser?.text = dataManager.userData[indexPath.row].userName as String
        
            var dateFormatter2 = NSDateFormatter()
            dateFormatter2.dateFormat = "dd/MM/yyyy"
            var strBd = dateFormatter2.stringFromDate(dataManager.userData[indexPath.row].userBirthDay)
            cell.birthDayUser?.text = strBd
        
            if(dataManager.userData[indexPath.row].gender == 1)
            {
                cell.avatarUser?.image = UIImage(named: "avatar_icon_boy")
            }
            else
            {
                cell.avatarUser?.image = UIImage(named: "avatar_icon_girl")
            }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
       
           }
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "AddFirstUser" {
            // perform your computation to determine whether segue should occur
            
            if dataManager.userData.count == 0 {
                return false
            }
        }
        
        // by default perform the segue transitio
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
       // self.navigationController?.popToRootViewControllerAnimated(true)
        if segue.identifier == "ChooseVaccine" {
            
            if let chooseVaccine = segue.destinationViewController as? ChooseVaccineController{
                chooseVaccine.userID = dataManager.userData[rowForEdit].userID
            
            }
        }
        else if segue.identifier == "EditUser" {
            
            if let editUser = segue.destinationViewController as? EditUserViewController{
                editUser.userID = dataManager.userData[rowForEdit].userID
                editUser.gender = dataManager.userData[rowForEdit].gender
                editUser.userName = dataManager.userData[rowForEdit].userName as String
                editUser.userBD = dataManager.userData[rowForEdit].userBirthDay
                
            }
        }

        
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var chooseVaccine =  UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Chọn vắc xin", handler: { (action, indexPath) -> Void in
            tableView.editing = false
            let editUser = ChooseVaccineController()
            self.rowForEdit = indexPath.row
            self.performSegueWithIdentifier("ChooseVaccine", sender: nil)
        })
        chooseVaccine.backgroundColor = UIColor.grayColor()
        var editInfo =  UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Sửa", handler: { (action, indexPath) -> Void in
            tableView.editing = false
            self.rowForEdit = indexPath.row
            self.performSegueWithIdentifier("EditUser", sender: nil)
        })
        editInfo.backgroundColor = UIColor.blueColor()
        var deleteInfo =  UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Xoá", handler: { (action, indexPath) -> Void in
            tableView.editing = false
            
            SweetAlert().showAlert("Sổ tiêm chủng?", subTitle: "Bạn có muốn xoá bé và sổ tiêm của bé không ? ", style: AlertStyle.Warning, buttonTitle:"Không", buttonColor:UIColorFromRGB(0xD0D0D0) , otherButtonTitle:  "Đồng ý", otherButtonColor: UIColorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    println("Cancel Button  Pressed")
                }
                else {
                    self.dataManager.deleteUser(self.dataManager.userData[indexPath.row].userID)
                    self.dataManager.userData.removeAtIndex(indexPath.row)
                    self.tableListUser.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    SweetAlert().showAlert("Đã xoá!", subTitle: "Toàn bộ thông tin của bé đã bị xoá", style: AlertStyle.Success)
                }
            }
           
        })
        
         return [chooseVaccine,editInfo,deleteInfo]
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var navController: UINavigationController = self.tabBarController?.viewControllers?[1] as! UINavigationController
      
        var injectBook = navController.viewControllers[0] as! InjectionBookAllViewController
    //    [search initWithText:@"This is a test"];
        injectBook.userID = dataManager.userData[indexPath.row].userID
        self.tabBarController!.selectedViewController = navController
        self.navigationController?.popViewControllerAnimated(true)
 
    }
}
