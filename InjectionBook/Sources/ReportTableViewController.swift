//
//  ReportTableViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/20/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class ReportTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

        let dataManager = DataManager()
        var userID = 0
        var sickRegister = [String]()
        var sickNumber = [Int]()
        var sickRegisterInfo = [SickRegisterInfo]()

    @IBOutlet weak var naviItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
           }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.getUserInfo()
        dataManager.getInjectionBook(userID)
        sickRegisterInfo = []
        sickRegister = []
        
        if dataManager.userData.count > 0
        {
            userID = dataManager.userData[0].userID
            naviItem.title = "Sổ tiêm "+dataManager.dictUserInfo[userID]!
            dataManager.getSickRegisterInfo(userID)
            dataManager.getSickInfo()
            dataManager.getInjectionBook(userID)
            for var i = 0; i < dataManager.sickRegisterData.count; i++
            {
                if dataManager.sickRegisterData[i].isSelected == 1 && dataManager.sickRegisterData[i].isEnable == 1
                {
                    let id = dataManager.sickRegisterData[i].sickID
                    sickRegister.append(dataManager.dictSickInfoCode[id]!)
                    sickRegisterInfo.append(dataManager.sickRegisterData[i])
                }
            }
        }
        else
        {
            
        }
        tableView.reloadData()
        tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonBack.frame = CGRectMake(0, 0, 40, 40)
        buttonBack.setImage(UIImage(named:"avatar_icon_boy"), forState: UIControlState.Normal)
        
        if  dataManager.dictUserGender[userID] == 0
        {
            buttonBack.setImage(UIImage(named:"avatar_icon_girl"), forState: UIControlState.Normal)
        }
        
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonBack.backgroundColor = UIColor.whiteColor()
        buttonBack.layer.cornerRadius = buttonBack.frame.height/2
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        tableView.reloadData()
        
    }
    
    func leftNavButtonClick(sender:UIButton!)
    {
        var viewController = UIStoryboard(name: "Main",
            bundle: nil).instantiateViewControllerWithIdentifier("idPopover") as! ChooseUserTableViewController
        
        viewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        viewController.popoverPresentationController?.delegate = self
        viewController.popoverPresentationController?.sourceView = sender
        viewController.popoverPresentationController?.permittedArrowDirections = .Any
        viewController.preferredContentSize = CGSizeMake(275.0, 375.0)
        
        // Present the popoverViewController's view on screen
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return sickRegisterInfo.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReportTableCell", forIndexPath: indexPath) as! ReportTableViewCell

       cell.sickCode?.text = sickRegister[indexPath.row]
       let id = sickRegisterInfo[indexPath.row].sickID
        let today = NSDate()
       
            for var i = 0;  i < dataManager.injectData.count ; i++
            {
                if dataManager.injectData[i].sickID == id
                {
                    var inject1 = MyCustomButton.buttonWithType(UIButtonType.Custom) as! MyCustomButton
                    var x   = CGFloat(30*dataManager.injectData[i].injectNumber)
                    inject1.frame = CGRectMake(x, 10, 25, 25)
                    var images = UIImage()
                    if dataManager.injectData[i].injectDate.isGreaterThanDate(today)
                    {
                        if dataManager.injectData[i].isInjection == 1
                        {
                            images = UIImage(named: "ic_injection_green")!
                        }
                        else
                        {
                            images = UIImage(named: "ic_injection_disable")!
                        }

                    }
                    else
                    {
                        if dataManager.injectData[i].isInjection == 1
                        {
                             images = UIImage(named: "ic_injection_green")!
                        }
                        else
                        {
                             images = UIImage(named: "ic_injection_red")!
                        }
                    }
                    inject1.setImage(images, forState: UIControlState.Normal)
                    inject1.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    inject1.sickID = dataManager.injectData[i].sickID
                    inject1.numberInject = dataManager.injectData[i].number
                    inject1.nameInject = dataManager.injectData[i].vaccineName
                    inject1.dateInject = dataManager.injectData[i].injectDate
                    inject1.isInject = dataManager.injectData[i].isInjection
                    inject1.note = dataManager.injectData[i].note
                    
                    cell.injectView.addSubview(inject1)
                }
            }
        
        return cell
        
    }
    func buttonAction(sender:MyCustomButton!)
    {
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.stringFromDate(sender.dateInject)
        var isInject = String()
        if sender.dateInject.isGreaterThanDate(today)
        {
            if sender.isInject == 0
            {
                isInject = "Chưa tiêm"
            }
            else
            {
                isInject = "Đã tiêm "
            }
        }
        else
        {
            if sender.isInject == 0
            {
                isInject = "Bỏ lỡ"
            }
            else
            {
                isInject = "Đã tiêm "
            }

        }
        
        let alert = UIAlertView(title:dataManager.dictSickInfo[sender.sickID], message:"Mũi tiêm : \(sender.numberInject) \n Tên vắc xin : \(sender.nameInject) \n Ngày tiêm : \(date) \n Trạng thái : \(isInject) \n Ghi chú : \(sender.note)", delegate:nil, cancelButtonTitle: "OK")
        alert.show()

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindFromModalViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "returnHome" {
            
            var sourceViewController: ChooseUserTableViewController = segue.sourceViewController as! ChooseUserTableViewController
            userID = sourceViewController.userID
            
            
            println(userID)

            var name: String = dataManager.dictUserInfo[userID]!
            self.naviItem.title = "Sổ tiêm \(name)"
            
            self.tableView.reloadData()
            self.viewWillAppear(true)
            // Dismiss the PopoverViewController's view
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }

}
