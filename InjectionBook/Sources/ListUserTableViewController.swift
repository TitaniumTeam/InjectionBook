//
//  ListUserTableViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/16/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit
import Social
class ListUserTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource
 {

    
    @IBOutlet var tableListUser: UITableView!
    let dataManager = DataManager()

    var rowForEdit = 0
    let localNotification = LocalNotification()
    var userID = 0
    override func viewDidLoad() {
        super.viewDidLoad()
          }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.getUserInfo()
        if dataManager.userData.count == 0
        {
            self.performSegueWithIdentifier("AddUser", sender: nil)
            self.navigationController?.navigationItem.title = "Thêm bé"
        }

        tableListUser.reloadData()
        self.navigationItem.title = "Danh sách bé"
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red:138/255, green:189/255, blue:68/255, alpha:1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.tabBarController?.tabBar.selectedImageTintColor = UIColor(red:138/255, green:189/255, blue:68/255, alpha:1)

        dataManager.getUserInfo()
        tableListUser.reloadData()
    
        if dataManager.userData.count == 0
        {
            self.performSegueWithIdentifier("AddFirtUser", sender: nil)
        }
        tableListUser.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)

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
                chooseVaccine.gender = dataManager.userData[rowForEdit].gender
                chooseVaccine.isEdit = true
                userID = dataManager.userData[rowForEdit].userID
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
                    self.dataManager.getUserInfo()
                    if self.dataManager.userData.count == 0
                    {
                        self.performSegueWithIdentifier("AddUser", sender: nil)
                        self.navigationItem.title = "Thêm bé"
                    }

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
        injectBook.index = indexPath.row
        self.tabBarController!.selectedViewController = navController
        self.navigationController?.popViewControllerAnimated(true)
        
        var navController1: UINavigationController = self.tabBarController?.viewControllers?[2] as! UINavigationController
        
        var report = navController1.viewControllers[0] as! ReportTableViewController
        report.userID = dataManager.userData[indexPath.row].userID
        report.index = indexPath.row
        
    }
    @IBAction func btnSetting(sender: UIBarButtonItem) {
        
        var alertController = UIAlertController()
        
        // Create the actions
        var settingAction = UIAlertAction(title: "Tuỳ chọn", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        var shareAction = UIAlertAction(title: "Chia sẻ Facebook", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            let firstActivityItem = "Hey, check out this mediocre site that sometimes posts about Swift!"
            
            let secondActivityItem : NSURL = NSURL(fileURLWithPath: "http://www.dvdowns.com/")!
            
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                UIActivityTypePrint,
                UIActivityTypeAssignToContact,
                UIActivityTypeSaveToCameraRoll,
                UIActivityTypeAddToReadingList,
                UIActivityTypePostToFlickr,
                UIActivityTypePostToVimeo,
                UIActivityTypePostToFacebook,
                UIActivityTypeMail
            ]
            self.presentViewController(activityViewController, animated: true, completion: nil)

            
        }
        var presentAction = UIAlertAction(title: "Giới thiệu", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        var ruleAction = UIAlertAction(title: "Điều khoản sử dụng", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        var cancelAction = UIAlertAction(title: "Huỷ", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(settingAction)
        alertController.addAction(shareAction)
        alertController.addAction(presentAction)
        alertController.addAction(ruleAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func unwindFromModalViewController(segue: UIStoryboardSegue) {
       if segue.identifier == "chooseDone"
       {
        
        var sourceViewController: ChooseVaccineController = segue.sourceViewController as! ChooseVaccineController
        
        if sourceViewController.isEdit == false
        {
        
            dataManager.getUserInfo()
            if sourceViewController.saveInfoVaccine() == true
            {
                
                self.dismissViewControllerAnimated(false, completion: nil)
                var navController: UINavigationController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        
                var injectBook = navController.viewControllers[0] as! InjectionBookAllViewController
        //    [search initWithText:@"This is a test"];
                injectBook.userID = dataManager.userData[dataManager.userData.count-1].userID
                injectBook.index = dataManager.userData.count-1
                self.tabBarController!.selectedViewController = navController
                self.navigationController?.popViewControllerAnimated(true)

                var navController1: UINavigationController = self.tabBarController?.viewControllers?[2] as! UINavigationController
        
                var report = navController1.viewControllers[0] as! ReportTableViewController
        //    [search initWithText:@"This is a test"];
                report.userID = dataManager.userData[dataManager.userData.count-1].userID
                report.index = dataManager.userData.count-1
                var isDone = 0
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                    println("gcd hello")
                    dispatch_async(dispatch_get_main_queue(), {
                        isDone = self.localNotification.scheduleNotification(self.dataManager.userData[self.dataManager.userData.count-1].userID)
                        
                        if isDone > 0
                        {
                            println("done")
                            FVCustomAlertView.shareInstance.hideAlertFromView(injectBook.view, fading: true)
                        }
                    })
                    
                })
                FVCustomAlertView.shareInstance.showDefaultLoadingAlertOnView(injectBook.view, withTitle: "Đang nhập dữ liệu...")

            }
        }
        else
        {
            if sourceViewController.saveInfoVaccine() == true
            {
                println("tét")
                dataManager.getUserInfo()
                self.dismissViewControllerAnimated(false, completion: nil)
                var navController: UINavigationController = self.tabBarController?.viewControllers?[0] as! UINavigationController
                //var injectBook = navController.viewControllers[0] as! InjectionBookAllViewController

                self.tabBarController!.selectedViewController = navController
                self.navigationController?.popViewControllerAnimated(true)
                var isDone = 0
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                    println("gcd hello")
                    dispatch_async(dispatch_get_main_queue(), {
                        isDone = self.localNotification.scheduleNotification(self.userID)
                        
                        if isDone > 0
                        {
                            println("done")
                            FVCustomAlertView.shareInstance.hideAlertFromView(self.view, fading: true)
                        }
                    })
                    
                })
                FVCustomAlertView.shareInstance.showDefaultLoadingAlertOnView(self.view, withTitle: "Đang nhập dữ liệu...")
                }
            }
        }
    }
}
