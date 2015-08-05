//
//  InjectionScheduleTableViewController.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/17/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class InjectionScheduleTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    let sections = ["Từ sơ sinh(Càng sớm càng tốt)", "2 tháng tuổi", "3 tháng tuổi", "4 tháng tuổi", "6 tháng tuổi", "7 tháng tuổi", "9 tháng tuổi","12 tháng tuổi","15 tháng tuổi","16 tháng tuổi","18 tháng tuổi","19 tháng tuổi","24 tháng tuổi", "2 năm 7 tháng tuổi", "3 năm 7 tháng tuổi", "5 tuổi", "5 tuổi 3 tháng", "8 tuổi", "9 tuổi", "9 năm 2 tháng tuổi","9 năm 3 tháng tuổi","9 năm 4 tháng tuổi","9 năm 6 tháng tuổi","11 tuổi","14 tuổi","17 tuổi"]
    var dataManager = DataManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.getSickInfo()
        dataManager.getInjectionSchedudleInfo()
       
    }
    override func viewWillAppear(animated: Bool) {
        tableView.scrollsToTop = true
        self.navigationItem.title = "Lịch tiêm chủng" 
        super.viewWillAppear(animated)
        dataManager.getSickInfo()
        dataManager.getInjectionSchedudleInfo()
        tableView.reloadData()
        tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:138/255, green:189/255, blue:68/255, alpha:1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataManager.injectionName[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InjectScheduleCell", forIndexPath: indexPath) as! UITableViewCell

        let indexId = dataManager.injectionName[indexPath.section][indexPath.row]
        
     
        
        cell.textLabel?.text = dataManager.sickData[indexId - 1].sickName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return self.sections[section]
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = (view as? UITableViewHeaderFooterView)!
        header.contentView.backgroundColor = UIColor(red:224/255, green:224/255, blue:224/255, alpha:1)
        header.textLabel.textColor = UIColor(red:130/255, green:176/255, blue:70/255, alpha:1)
    }

    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath ){
        let cell = tableView.dequeueReusableCellWithIdentifier("InjectScheduleCell", forIndexPath: indexPath) as! UITableViewCell
        let indexId = dataManager.injectionName[indexPath.section][indexPath.row]
       
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Left
        
        let messageText = NSMutableAttributedString(
            string: dataManager.sickData[indexId - 1].sickdes,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
                NSForegroundColorAttributeName : UIColor.blackColor()
            ]
        )
        
        
             cell.textLabel?.text = dataManager.sickData[indexId - 1].sickName
            let alert = UIAlertView(title: dataManager.sickData[indexId - 1].sickName, message: dataManager.sickData[indexId - 1].sickdes, delegate:nil, cancelButtonTitle: "OK")
                       alert.show()
        cell.selected = false
        
    }

}
