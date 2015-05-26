//
//  InjectionBookAllViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/19/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit



class InjectionBookAllViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var dataManager = DataManager()
    
    @IBOutlet weak var naviItem: UINavigationItem!
    var dataInjectBook: [InjectionBookInfo] = []
    var dataInjectBookPass: [InjectionBookInfo] = []
    var dataInjectBookFuture: [InjectionBookInfo] = []
    var userID = 0
    var section: [NSDate] = []
    var inJectInSection: [InjectionBookInfo] = []
    var sectionName = [String]()
    var indexSegment = Int()
    

    
    @IBOutlet weak var segment: UISegmentedControl!
    var sectionTitleArray = [String]()
    var sectionContentDict : NSMutableDictionary = NSMutableDictionary()
    var arrayForBool : NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        segment.selectedSegmentIndex = 0
        self.tableView.scrollsToTop = true
        dataManager.getUserInfo()
        if dataManager.userData.count > 0
        {
            
            if userID < 1
            {
                dataManager.getUserInfo()
                userID = dataManager.userData[0].userID
            }
            dataManager.getInjectionBook(userID);
            dataManager.getSickInfo()
            dataInjectBookFuture = [InjectionBookInfo]()
            dataInjectBook = [InjectionBookInfo]()
            let today = NSDate()
            
            for var i = 0; i <  dataManager.injectData.count; i++
            {
                if dataManager.injectData[i].injectDate.isGreaterThanDate(today)
                {
                    if dataManager.injectData[i].inactive == 0
                    {
                        dataInjectBookFuture.append(dataManager.injectData[i])
                        
                    }
                }
            }
            dataInjectBook = dataInjectBookFuture
            
            dataManager.sortBySectionBook(dataInjectBook)
            sectionName = []
            for injectInfo in dataManager.injectBookName
            {
                
                var sectionDate = injectInfo[0].injectDate
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/yyyy"
                var sectionStr = "Tháng " + dateFormatter.stringFromDate(sectionDate)
                sectionName.append(sectionStr)
                
            }
        }
        else
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        if self.isMovingFromParentViewController()
        {
            self.navigationController?.performSegueWithIdentifier("ReturnInjectBook", sender: nil)
        }
        naviItem.title = "Sổ tiêm "+dataManager.dictUserInfo[userID]!
        naviItem.hidesBackButton = true
        tableView.delegate = self
        tableView.dataSource = self
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
    @IBAction func chooseUser(sender: AnyObject) {
       
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

    @IBAction func segmentChange(sender: UISegmentedControl) {
        self.tableView.scrollsToTop = true
        dataInjectBookFuture = []
        dataInjectBook = []
        if sender.selectedSegmentIndex == 0 {
            let today = NSDate()
            dataInjectBook = []
            dataManager.getInjectionBook(userID);
            dataManager.getSickInfo()
            for var i = 0; i <  dataManager.injectData.count; i++
            {
                if dataManager.injectData[i].injectDate.isGreaterThanDate(today)
                {
                    if dataManager.injectData[i].inactive == 0
                    {
                        dataInjectBookFuture.append(dataManager.injectData[i])
                    }
                }
            }
            dataInjectBook = dataInjectBookFuture
            dataManager.sortBySectionBook(dataInjectBook)
            sectionName = []
            for injectInfo in dataManager.injectBookName
            {
                
                var sectionDate = injectInfo[0].injectDate
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/yyyy"
                var sectionStr = "Tháng " + dateFormatter.stringFromDate(sectionDate)
                sectionName.append(sectionStr)
                
            }
            
            tableView.reloadData()
            indexSegment = 0
        }else if sender.selectedSegmentIndex == 1 {
            dataInjectBookPass = []
            dataInjectBook = []
            let today = NSDate()
            for var i = 0; i <  dataManager.injectData.count; i++
            {
                if dataManager.injectData[i].injectDate.isLessThanDate(today)
                {
                    if dataManager.injectData[i].inactive == 0
                    {
                        dataInjectBookPass.append(dataManager.injectData[i])
                    }
                }
            }
            dataInjectBook = dataInjectBookPass
            tableView.reloadData()
            dataManager.sortBySectionBook(dataInjectBook)
            sectionName = []
            for injectInfo in dataManager.injectBookName
            {
                
                var sectionDate = injectInfo[0].injectDate
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/yyyy"
                var sectionStr = "Tháng " + dateFormatter.stringFromDate(sectionDate)
                sectionName.append(sectionStr)
            }
            indexSegment = 1
        }else if sender.selectedSegmentIndex == 2 {
            dataManager.getUserInfo()
            dataManager.getInjectionBook(userID)
            naviItem.title = "Sổ tiêm "+dataManager.dictUserInfo[userID]!
            dataManager.getSickRegisterInfo(userID)
            dataManager.getSickInfo()
            dataManager.getInjectionBook(userID)
            sectionName = []
            var sickID = [Int]()
            for var i = 0; i < dataManager.sickRegisterData.count; i++
            {
                if dataManager.sickRegisterData[i].isSelected == 1 && dataManager.sickRegisterData[i].isEnable == 1
                {
                    let id = dataManager.sickRegisterData[i].sickID
                    sectionName.append(dataManager.dictSickInfo[id]!)
                    sickID.append(dataManager.sickRegisterData[i].sickID)
                }
            }
            dataManager.getReportAllInSection(sickID, id: userID)
            indexSegment = 2
        }
        
        tableView.reloadData()
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sectionName.count
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataManager.injectBookName[section].count
    }
    
    
         func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sectionName[section]
    }
    
     func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if indexSegment == 0 || indexSegment == 1
        {
            let header: UITableViewHeaderFooterView = (view as? UITableViewHeaderFooterView)!
            header.contentView.backgroundColor = UIColor.grayColor()
            header.textLabel.textColor = UIColor.greenColor()
        }
     else
        {
            let header: UITableViewHeaderFooterView = (view as? UITableViewHeaderFooterView)!
            header.contentView.backgroundColor = UIColor.grayColor()
            header.textLabel.textColor = UIColor.greenColor()
            //let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
           // header .addGestureRecognizer(headerTapped)
                
        }
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        var indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if (indexPath.row == 0) {
            
            var collapsed = arrayForBool .objectAtIndex(indexPath.section).boolValue
            collapsed       = !collapsed;
            
            arrayForBool .replaceObjectAtIndex(indexPath.section, withObject: collapsed)
            //reload specific section animated
            var range = NSMakeRange(indexPath.section, 1)
            var sectionToReload = NSIndexSet(indexesInRange: range)
            self.tableView .reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InjectionBookCell", forIndexPath: indexPath) as! InjectionBookTableViewCell
        
        tableView.sectionIndexColor = UIColor.greenColor()
        
        if indexSegment == 2
        {
            
            
            let indexId = dataManager.injectBookName[indexPath.section][indexPath.row].sickID
            cell.sickName?.text = dataManager.dictSickInfo[indexId]
            cell.numberInjection?.text = "Mũi "+dataManager.injectBookName[indexPath.section][indexPath.row].number
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            var daySub = dataManager.injectBookName[indexPath.section][indexPath.row].injectDate
            var daySubStr = dateFormatter.stringFromDate(daySub)
            
            var dayOfWeekInt = daySub.getDayOfWeek(daySubStr)
            var dayOfWeekStr = String()
            if dayOfWeekInt == 2
            {
                dayOfWeekStr = "Thứ 2"
            }
            else if dayOfWeekInt == 3
            {
                dayOfWeekStr = "Thứ 3"
            }
            else if dayOfWeekInt == 4
            {
                dayOfWeekStr = "Thứ 4"
            }
            else if dayOfWeekInt == 5
            {
                dayOfWeekStr = "Thứ 5"
            }
            else if dayOfWeekInt == 6
            {
                dayOfWeekStr = "Thứ 6"
            }
            else if dayOfWeekInt == 7
            {
                dayOfWeekStr = "Thứ 7"
            }
            else if dayOfWeekInt == 1
            {
                dayOfWeekStr = "Chủ nhật"
            }
            cell.dayInjection?.text = dayOfWeekStr + " - " + daySubStr
            
            let today = NSDate()
            
            cell.isInjectImg?.hidden = false
            if dataManager.injectBookName[indexPath.section][indexPath.row].isInjection == 0 && dataManager.injectBookName[indexPath.section][indexPath.row].injectDate.isLessThanDate(today)
                {
                    cell.isInjectImg?.image = UIImage(named: "ic_disable")
                }
            else if dataManager.injectBookName[indexPath.section][indexPath.row].isInjection == 0 && dataManager.injectBookName[indexPath.section][indexPath.row].injectDate.isGreaterThanDate(today)
                {
                    cell.isInjectImg?.hidden = true
                }
                else
                {
                    cell.isInjectImg?.image = UIImage(named: "ic_check")
                }
        }
        else
        {
            let indexId = dataManager.injectBookName[indexPath.section][indexPath.row].sickID
            
            cell.sickName?.text = dataManager.dictSickInfo[indexId]
            
            var daySub = dataManager.injectBookName[indexPath.section][indexPath.row].injectDate
            cell.numberInjection?.text = "Mũi "+dataManager.injectBookName[indexPath.section][indexPath.row].number
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            var daySubStr = dateFormatter.stringFromDate(daySub)
            
            var dayOfWeekInt = daySub.getDayOfWeek(daySubStr)
            var dayOfWeekStr = String()
            if dayOfWeekInt == 2
            {
                dayOfWeekStr = "Thứ 2"
            }
            else if dayOfWeekInt == 3
            {
                dayOfWeekStr = "Thứ 3"
            }
            else if dayOfWeekInt == 4
            {
                dayOfWeekStr = "Thứ 4"
            }
            else if dayOfWeekInt == 5
            {
                dayOfWeekStr = "Thứ 5"
            }
            else if dayOfWeekInt == 6
            {
                dayOfWeekStr = "Thứ 6"
            }
            else if dayOfWeekInt == 7
            {
                dayOfWeekStr = "Thứ 7"
            }
            else if dayOfWeekInt == 1
            {
                dayOfWeekStr = "Chủ nhật"
            }
            cell.dayInjection?.text = dayOfWeekStr + " - " + daySubStr
            
            if indexSegment == 1
            {
                cell.isInjectImg?.hidden = false
                if dataManager.injectBookName[indexPath.section][indexPath.row].isInjection == 0
                {
                    cell.isInjectImg?.image = UIImage(named: "ic_disable")
                }
                else
                {
                    cell.isInjectImg?.image = UIImage(named: "ic_check")
                }
            }
            else if indexSegment == 0
            {
                cell.isInjectImg?.hidden = true
                if dataManager.injectBookName[indexPath.section][indexPath.row].isInjection == 0
                {
                    cell.isInjectImg?.hidden = true
                    
                }
                else
                {
                    cell.isInjectImg?.hidden = false
                    cell.isInjectImg?.image = UIImage(named: "ic_check")
                }
                
            }
            else
            {
                cell.isInjectImg?.hidden = true
            }
        }
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditInject" {
            if let editInject = segue.destinationViewController as? EditInjectViewController{
                if let injectIndex = tableView.indexPathForSelectedRow()?.row
                {
                    if let injectSection = tableView.indexPathForSelectedRow()?.section
                    {
                        let indexId = dataManager.injectBookName[injectSection][injectIndex].sickID
                        editInject.sickNameLabel = dataManager.sickData[indexId - 1].sickName
                        editInject.numberInjectLabel = dataManager.injectBookName[injectSection][injectIndex].number
                        editInject.dateInjectTF = dataManager.injectBookName[injectSection][injectIndex].injectDate
                        editInject.isInjectBtn = dataManager.injectBookName[injectSection][injectIndex].isInjection
                        editInject.idBook = dataManager.injectBookName[injectSection][injectIndex].id
                        editInject.nameInjectTF = dataManager.injectBookName[injectSection][injectIndex].vaccineName
                        editInject.noteInjectTF = dataManager.injectBookName[injectSection][injectIndex].note
                    }
                    
                }
            }
        }
        
    }
   @IBAction func unwindFromModalViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "returnHome" {
           
            var sourceViewController: ChooseUserTableViewController = segue.sourceViewController as! ChooseUserTableViewController
            
      
            var name: String = dataManager.dictUserInfo[sourceViewController.userID]!
            self.navigationItem.title = "Sổ tiêm \(name)"
            userID = sourceViewController.userID
            self.tableView.reloadData()
            self.viewWillAppear(true)
            // Dismiss the PopoverViewController's view
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }

}
