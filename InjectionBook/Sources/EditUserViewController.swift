//
//  EditUserViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/19/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController , UITextFieldDelegate{

    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var userBDTF: UITextField!
    @IBOutlet weak var userAvatar: UIImageView!
    
    let db = SQLiteDB.sharedInstance()
 //   var popDatePicker : PopDatePicker?
    var gender = Int()
    var userName = String()
    var userBD = NSDate()
    var userID = Int()
    let dataManager = DataManager()
    let localNotification = LocalNotification()
    var done = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        done = 0
        userAvatar.layer.cornerRadius = 10
        
        userNameTF.text = userName
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        userBDTF.text = dateFormatter.stringFromDate(userBD)
        if gender == 1
        {
            userAvatar.image = UIImage(named: "avatar_icon_boy")
            genderLabel.text = "Giới tính: Nam"
        }
        else
        {
            userAvatar.image = UIImage(named: "avatar_icon_girl")
            genderLabel.text = "Giới tính: Nữ"
        }
   //     popDatePicker = PopDatePicker(forTextField: userBDTF)
        userBDTF.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationItem.title = "Sửa thông tin"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    func resign() {
        userBDTF.resignFirstResponder()
        userNameTF.resignFirstResponder()
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (textField == userBDTF) {
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(userBDTF.text)
            
//            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
//                self.userBD = newDate
//                // here we don't use self (no retain cycle)
//                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
//                
//            }
//            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
        }
        else {
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnMale(sender: UIButton) {
        genderLabel.text = "Giới tính : Nam"
        gender = 1
        userAvatar.image = UIImage(named: "avatar_icon_boy")
    }
    
    @IBAction func btnFemale(sender: UIButton) {
        genderLabel.text = "Giới tính : Nữ"
        gender = 0
        userAvatar.image = UIImage(named: "avatar_icon_girl")
    }
    
    @IBAction func saveEditUser(sender: UIButton) {
        if userNameTF.text.isEmpty {
            let alert = UIAlertView(title:"Sổ tiêm chủng", message:"Điền tên của bé", delegate:nil, cancelButtonTitle: "OK")
            alert.show()
        }
        else if userBDTF.text.isEmpty
        {
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(userBDTF.text)
            
//            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
//                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
//                self.userBD = newDate
//            }
//            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
        }
        else {
            let db = SQLiteDB.sharedInstance()
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var dateStr = dateFormatter.stringFromDate(userBD)
            var date: NSDate = dateFormatter.dateFromString(dateStr)!
            let sql = "UPDATE User SET Name = '\(userNameTF.text)', Gender = '\(gender)', Birthday = '\(userBD)' WHERE UserID = \(userID) "
            let rc = db.execute(sql)
            
            dataManager.getUserInfo()
            dataManager.getInjectionSchedudleInfo()
            dataManager.getInjectionBook(userID)
            
            let numberRecordBook = dataManager.injectData.last!.id
        
            let idBook = numberRecordBook - dataManager.injectData.count+1
            for var index = 0; index < dataManager.injectionScheduleData.count; index++
            {
                let row = dataManager.injectionScheduleData[index]
                let subMonth = row.subMoth
                let tomorrow: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: subMonth,toDate: date,
                    options: NSCalendarOptions(0))!
                let sql = "UPDATE InjectionBook SET InjectionDate = '\(tomorrow)' WHERE InjectionBookID = \(idBook+index)"
                let rc = db.execute(sql)
            }
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
            FVCustomAlertView.shareInstance.showDefaultLoadingAlertOnView(self.view, withTitle: "Đang nhập dữ liệu")

        }
    }
}
