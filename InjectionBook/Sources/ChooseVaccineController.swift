//
//  ChooseVaccineController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/21/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class ChooseVaccineController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var dataManager = DataManager()
    var userID = 1;
    var sickRegister = [SickRegisterInfo]()
    let db = SQLiteDB.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
           }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Chọn vắc xin"
        dataManager.getSickRegisterInfo(userID)
        dataManager.getSickInfo()
        for sickRegisterData in dataManager.sickRegisterData
        {
            if sickRegisterData.isEnable == 1
            {
                sickRegister.append(sickRegisterData)
            }
        }
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return sickRegister.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChooseVaccineCell", forIndexPath: indexPath) as! ChooseVaccineViewCell
        
        // Configure the cell...
        cell.sickName?.text = dataManager.dictSickInfo[sickRegister[indexPath.row].sickID]
        cell.sickID = sickRegister[indexPath.row].sickID
        
        
        
        if sickRegister[indexPath.row].boolSelected
        {
            cell.isCheck.image = UIImage(named: "ic_checked")
            cell.intSelected = 1
            sickRegister[indexPath.row].isSelected = 1
        }
        else
        {
            cell.isCheck.image = UIImage(named: "ic_uncheck")
            cell.intSelected = 0
            sickRegister[indexPath.row].isSelected = 0
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
       sickRegister[indexPath.row].boolSelected = !sickRegister[indexPath.row].boolSelected
        tableView.reloadData()
    
    }
    
    @IBAction func btnSaveVaccine(sender: UIBarButtonItem) {
        
        for sickRegisterInfo in sickRegister
        {
            let sql = "UPDATE SickRegister SET Selected = '\(sickRegisterInfo.isSelected)' WHERE UserID = \(sickRegisterInfo.userID) AND SickID =  \(sickRegisterInfo.sickID)"
            let rc = db.execute(sql)
        }
        var navController: UINavigationController = self.tabBarController?.viewControllers?[1] as! UINavigationController
        scheduleNotification(userID)
        var injectBook = navController.viewControllers[0] as! InjectionBookAllViewController
        //    [search initWithText:@"This is a test"];
        injectBook.userID = sickRegister[0].userID
        self.tabBarController!.selectedViewController = navController
        self.navigationController?.popViewControllerAnimated(true)
    }
    func scheduleNotification(userID:Int){
        
        //cancelNotification(userID)
        println("bac")
        dataManager.getInjectionBook(userID)
        dataManager.getUserInfo()
        for var i = 0; i <  dataManager.injectData.count; i++
        {
            var localNotification = UILocalNotification()
            
            localNotification.fireDate = dataManager.injectData[i].injectDate.dateByAddingTimeInterval(1)
            
            
            let indexId = dataManager.injectData[i].sickID
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            var daySubStr = dateFormatter.stringFromDate(dataManager.injectData[i].injectDate)
            
            var dayOfWeekInt = dataManager.injectData[i].injectDate.getDayOfWeek(daySubStr)
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
            
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            var sickName: String = dataManager.dictSickInfo[indexId]!
            localNotification.alertBody = "\(dayOfWeekStr) \(daySubStr)  tiêm  \(sickName)  mũi \(dataManager.injectData[i].number)"
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.alertTitle = "Sổ tiêm " + dataManager.dictUserInfo[userID]!
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }

}