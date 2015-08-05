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
    @IBOutlet weak var chooseAllbtn: UIButton!
    var dataManager = DataManager()
    var userID = 1;
    var sickRegister = [SickRegisterInfo]()
    let db = SQLiteDB.sharedInstance()
    var ischooseALl = false
    var isClick = Bool()
    var gender = 0
    var isEdit = false
    let localNotification = LocalNotification()
    override func viewDidLoad() {
        super.viewDidLoad()
           }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Chọn vắc xin"
    
        dataManager.getSickRegisterInfo(userID)
        dataManager.getSickInfo()
      //  dataManager.getUserInfo()
        for sickRegisterData in dataManager.sickRegisterData
        {
            if sickRegisterData.isEnable == 1
            {
                sickRegister.append(sickRegisterData)
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.hidesBackButton = true
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
        
       if self.ischooseALl == true
       {
            cell.isCheck.image = UIImage(named: "ic_checked")
            cell.intSelected = 1
            sickRegister[indexPath.row].isSelected = 1
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

        }
        else if self.ischooseALl == false
       {
        
        if isClick == true
        {
            cell.isCheck.image = UIImage(named: "ic_uncheck")
            cell.intSelected = 0
            sickRegister[indexPath.row].isSelected = 0
            
        }
        else
        {
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
        
        }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
       sickRegister[indexPath.row].boolSelected = !sickRegister[indexPath.row].boolSelected
        tableView.reloadData()
    
    }
    
    @IBAction func chooseAll(sender: UIButton) {
        
        self.ischooseALl = !self.ischooseALl
      //  tableView.reloadData()
        let check = sender as UIButton
        self.isClick = !isClick
        if self.ischooseALl == true
        {
            chooseAllbtn.setImage(UIImage(named: "ic_checked"), forState: nil)
        }
        else
        {
            chooseAllbtn.setImage(UIImage(named: "ic_uncheck"), forState: nil)
        }
        
        for var i = 0; i < sickRegister.count; i++
        {if self.ischooseALl == true
        {
             sickRegister[i].boolSelected = true
            sickRegister[i].isSelected = 1

        }
        else
        {
            sickRegister[i].boolSelected = false
            sickRegister[i].isSelected = 1

            }
                    }
        
        tableView.reloadData()
    }

    
    func saveInfoVaccine()->Bool
    {
        if gender == 0
        {
            if (sickRegister[2].isSelected == 1 &&  sickRegister[3].isSelected == 1) || (sickRegister[13].isSelected == 1 &&  sickRegister[14].isSelected == 1)
            {
                if sickRegister[2].isSelected == 1 &&  sickRegister[3].isSelected == 1
                {
                    
                    let alert = UIAlertView(title:"Sổ tiêm chủng", message:"Bạn không được chọn cả 2 loại vắc xin Rota virus", delegate:nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                else if sickRegister[13].isSelected == 1 &&  sickRegister[14].isSelected == 1
                {
                    
                    
                    let alert = UIAlertView(title:"Sổ tiêm chủng", message:"Bạn không được chọn cả 2 loại vắc xin Ung thư cổ tử cung", delegate:nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                return false
            }
                
            else
            {
                for sickRegisterInfo in sickRegister
                {
                    let sql = "UPDATE SickRegister SET Selected = '\(sickRegisterInfo.isSelected)' WHERE UserID = \(sickRegisterInfo.userID) AND SickID =  \(sickRegisterInfo.sickID)"
                    let rc = db.execute(sql)
                }
              
        
                return true
            }
            
        }
        else
        {
            if sickRegister[2].isSelected == 1 &&  sickRegister[3].isSelected == 1
            {
                let alert = UIAlertView(title:"Sổ tiêm chủng", message:"Bạn không được chọn cả 2 loại vắc xin Rota virus", delegate:nil, cancelButtonTitle: "OK")
                alert.show()
                return false
            }
            else
            {
                for sickRegisterInfo in sickRegister
                {
                    let sql = "UPDATE SickRegister SET Selected = '\(sickRegisterInfo.isSelected)' WHERE UserID = \(sickRegisterInfo.userID) AND SickID =  \(sickRegisterInfo.sickID)"
                    let rc = db.execute(sql)
                }
            
                return true
            }
            
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        var isShow =  false
        if identifier == "chooseDone"
        {
            if gender == 0
            {
                if (sickRegister[2].isSelected == 1 &&  sickRegister[3].isSelected == 1) || (sickRegister[13].isSelected == 1 &&  sickRegister[14].isSelected == 1)
                {
                    if sickRegister[2].isSelected == 1 &&  sickRegister[3].isSelected == 1
                    {
                        
                        let alert = UIAlertView(title:"Sổ tiêm chủng", message:"Bạn không được chọn cả 2 loại vắc xin Rota virus", delegate:nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                    else if sickRegister[13].isSelected == 1 &&  sickRegister[14].isSelected == 1
                    {
                        
                        
                        let alert = UIAlertView(title:"Sổ tiêm chủng", message:"Bạn không được chọn cả 2 loại vắc xin Ung thư cổ tử cung", delegate:nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                    isShow = false
                }
                    
                else
                {
                    isShow = true
                }
                
            }
            else
            {
                if sickRegister[2].isSelected == 1 &&  sickRegister[3].isSelected == 1
                {
                    let alert = UIAlertView(title:"Sổ tiêm chủng", message:"Bạn không được chọn cả 2 loại vắc xin Rota virus", delegate:nil, cancelButtonTitle: "OK")
                    alert.show()
                    isShow = false
                }
                else
                {
                    isShow = true
                }
                
            }

        }
        return isShow
    }
    }
