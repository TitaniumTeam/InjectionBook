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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popDatePicker = PopDatePicker(forTextField: userBirthDay)
        userBirthDay.delegate = self

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
                let tomorrow: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: subMonth,toDate: date,
                            options: NSCalendarOptions(0))!
               
                let sql = "UPDATE InjectionBook SET InjectionDate = '\(tomorrow)' WHERE InjectionBookID = \(idBook+index)"
            
                let rc = db.execute(sql)
            }
        }
        
     }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
       
        if segue.identifier == "ChooseVaccine" {
          
            if let chooseVaccineView = segue.destinationViewController as? ChooseVaccineController{
                dataManager.getUserInfo()
                if let userIndex: Int = dataManager.userData.last?.userID
                {
                    chooseVaccineView.userID = userIndex
                   
                }
            }
        }

        
    }
   }
