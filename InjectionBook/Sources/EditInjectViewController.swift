//
//  EditInjectViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/19/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class EditInjectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sickName: UILabel!
    @IBOutlet weak var noteInject: UITextField!
    @IBOutlet weak var dateInject: UITextField!
    @IBOutlet weak var nameInject: UITextField!
    @IBOutlet weak var numberInject: UILabel!
    @IBOutlet weak var isInject: UIButton!
    @IBOutlet weak var editView: UIView!
   
  
    var sickNameLabel = String()
    var numberInjectLabel = String()
    var dateInjectTF = NSDate()
    var noteInjectTF = String()
    var isInjectBtn = Int()
    var idBook = Int()
    var nameInjectTF = String()
    var dateInjectFix = NSDate()
    var dateToUpdate = NSDate()
    var isChangeDate = false
    let db = SQLiteDB.sharedInstance()
    var userID = 0
    var index = 0
    var segmentSelect = 0
    var nextDate = NSDate()
    override func viewDidLoad() {
        super.viewDidLoad()

        editView.layer.cornerRadius = 15
        editView.layer.shadowColor = UIColor.blackColor().CGColor
        sickName.text = sickNameLabel
        let dateFormat = NSDateFormatter()
        numberInject.text = numberInjectLabel
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateInject.text = dateFormat.stringFromDate(dateInjectTF)
        
        if isInjectBtn == 1
        {
            let images = UIImage(named: "ic_checked")
            isInject.setImage(images, forState: UIControlState.Normal)

        }
        nameInject.text = nameInjectTF
        noteInject.text = noteInjectTF
        
      //  popDatePicker = PopDatePicker(forTextField: dateInject)
        self.navigationItem.backBarButtonItem?.title = ""
        dateInject.delegate = self
       self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
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
    }
    
 
    @IBAction func isInjectBtn(sender: UIButton) {
        if isInjectBtn == 1
        {
            isInjectBtn = 0
            let images = UIImage(named: "ic_uncheck")
            isInject.setImage(images, forState: UIControlState.Normal)
        
        }
        else if isInjectBtn == 0
        {
            isInjectBtn = 1
            let images = UIImage(named: "ic_checked")
            isInject.setImage(images, forState: UIControlState.Normal)
        }
    }
   
    func resign() {
        
        dateInject.resignFirstResponder()
            }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if (textField == dateInject) {
            isChangeDate = true
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(dateInject.text)
            
//            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
//                self.dateInjectFix = newDate
//                // here we don't use self (no retain cycle)
//                let dateFormatter = NSDateFormatter()
//                dateFormatter.dateFormat = "dd/MM/yyyy"
//                forTextField.text = dateFormatter.stringFromDate(newDate)
//                
//            }
            
       //     popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
        }
        else {
            return true
        }
    }

    
    @IBAction func saveEdit(sender: UIButton) {
        
        if isChangeDate{
            dateToUpdate = dateInjectFix
        }
        else{
            dateToUpdate = dateInjectTF
        }
        let sql = "UPDATE InjectionBook SET IsInjection = '\(isInjectBtn)' , VaccineName = '\(nameInject.text)', Description = '\(noteInject.text)', InjectionDate = '\(dateToUpdate)' WHERE InjectionBookID = \(idBook)"
        let rc = db.execute(sql)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if let inject = segue.destinationViewController as? InjectionBookAllViewController
        {
            inject.userID = userID
            inject.index = index
          //  inject.indexSegment = segmentSelect
        }
    }

 
    @IBAction func cancelEdit(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
