//
//  AddUserViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/16/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController , UITextFieldDelegate{

   
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userBirthDay: UITextField!
    @IBOutlet weak var userSex: UILabel!
    var popDatePicker : PopDatePicker?
  
    @IBOutlet weak var userAvatar: UIImageView!
    let db = SQLiteDB.sharedInstance()
    var isgender = true
    var strDate = ""
    var bdUser = NSDate()
    var dataManager = DataManager()
    
    let localNotification = LocalNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        dataManager.getUserInfo()
        if dataManager.userData.count == 0
        {
            self.navigationController?.navigationItem.title = "Thêm bé"
            self.navigationController?.navigationItem.hidesBackButton = true
        }
        popDatePicker = PopDatePicker(forTextField: userBirthDay)
        userBirthDay.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationItem.title = "Thêm bé"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       
        
   }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePlayerDetail(segue:UIStoryboardSegue) {
        
    }
    
    func resign() {
        
        userBirthDay.resignFirstResponder()
        userName.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if (textField == userBirthDay) {
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(userBirthDay.text)
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
                self.bdUser = newDate
                // here we don't use self (no retain cycle)
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
                
            }
            
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
        }
        else {
            return true
        }
    }

    @IBAction func btnMale(sender: UIButton) {
        userSex.text = "Giới tính : Nam"
        isgender = true
        userAvatar.image = UIImage(named: "avatar_icon_boy")

    }

    @IBAction func btnFemale(sender: UIButton) {
        userSex.text = "Giới tính : Nữ"
        isgender = false
        userAvatar.image = UIImage(named: "avatar_icon_girl")

    }
    
   
    @IBAction func btnSaveUser(sender: UIButton) {
        if userName.isFirstResponder() {
            userName.resignFirstResponder()
        }
        // Validations
        if userName.text.isEmpty {
            let alert = UIAlertView(title:"Sổ tiêm chủng", message:"Điền tên của bé", delegate:nil, cancelButtonTitle: "OK")
            alert.show()
        }
        else if userBirthDay.text.isEmpty
        {
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(userBirthDay.text)
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
            }
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
        }
            // Save task
        else {
            let db = SQLiteDB.sharedInstance()
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var dateStr = dateFormatter.stringFromDate(bdUser)
            var date: NSDate = dateFormatter.dateFromString(dateStr)!
            var flag = (isgender) ? 1 : 0
 
            let sql = "INSERT INTO User(Name , Birthday, Gender) VALUES ('\(userName.text)', '\(date)','\(flag)')"
            let rc = db.execute(sql)
            var i = 0;
            dataManager.getUserInfo()
            dataManager.getInjectionSchedudleInfo()
            dataManager.getInjectionBook(dataManager.userData[dataManager.userData.count-1].userID)
            let numberRecordBook = db.query("SELECT * FROM InjectionBook")
            let idBook = dataManager.injectData.last!.id - dataManager.injectData.count+1
            for var index = 0; index < dataManager.injectionScheduleData.count; index++
            {
                let row = dataManager.injectionScheduleData[index]
                let subMonth = row.subMoth
                var tomorrow: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: subMonth,toDate: date,
                            options: NSCalendarOptions(0))!
                if subMonth == 204
                {
                    tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitYear, value: 17,toDate: date,
                    options: NSCalendarOptions(0))!
                    println("test thuong han")
                                   }
                if row.sickID == 9 && row.number > 1
                {
                    println("vnnb")
                    var tomorrow1: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: subMonth,toDate: date,
                        options: NSCalendarOptions(0))!
                    tomorrow =  NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: 7,toDate: tomorrow1,
                        options: NSCalendarOptions(0))!
                
                }
                let sql = "UPDATE InjectionBook SET InjectionDate = '\(tomorrow)' WHERE InjectionBookID = \(idBook+index)"
                println(tomorrow)
                println(idBook+index)
                let rc = db.execute(sql)
            }
            var isDone = 0
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                println("gcd hello")
                dispatch_async(dispatch_get_main_queue(), {
                    isDone = self.localNotification.scheduleNotification(self.dataManager.userData[self.dataManager.userData.count-1].userID)
                
                        if isDone > 0
                        {
                            FVCustomAlertView.shareInstance.hideAlertFromView(self.view, fading: true)
                        }

                    

                })
                
            })
            FVCustomAlertView.shareInstance.showDefaultLoadingAlertOnView(self.view, withTitle: "Đang nhập dữ liệu")

        }
        
     }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChooseVaccine" {
          
            if let chooseVaccineView = segue.destinationViewController as? ChooseVaccineController{
                dataManager.getUserInfo()
                if let userIndex: Int = dataManager.userData.last?.userID
                {
                    chooseVaccineView.userID = userIndex
                    chooseVaccineView.gender = dataManager.dictUserGender[userIndex]!
                    chooseVaccineView.isEdit = false
                }
            }
        }
        
    }
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        var should = true
        if identifier == "ChooseVaccine" || identifier == "returnHome"{
            if userBirthDay.text.isEmpty || userName.text.isEmpty
            {
                should = false
            }
        }
        return should
    }
}
