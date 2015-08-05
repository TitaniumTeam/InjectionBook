//
//  LocalNotification.swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/28/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class LocalNotification: NSObject {
    let dataManager = DataManager()
    private let ITEMS_KEY = "todoItems"
    var response = Dictionary<Int, UILocalNotification>()
func initNoti()

    {
        setupNotificationSettings()
    
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleModifyListNotification", name: "modifyListNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDeleteListNotification", name: "deleteListNotification", object: nil)
    }


func setupNotificationSettings() {
    let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
    
    if (notificationSettings.types == UIUserNotificationType.None){
        // Specify the notification types.
        var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        
        
        // Specify the notification actions.
        var justInformAction = UIMutableUserNotificationAction()
        justInformAction.identifier = "justInform"
        justInformAction.title = "Đã nhận"
        justInformAction.activationMode = UIUserNotificationActivationMode.Background
        justInformAction.destructive = false
        justInformAction.authenticationRequired = false
        
        var modifyListAction = UIMutableUserNotificationAction()
        modifyListAction.identifier = "editList"
        modifyListAction.title = "Chỉnh sửa"
        modifyListAction.activationMode = UIUserNotificationActivationMode.Foreground
        modifyListAction.destructive = false
        modifyListAction.authenticationRequired = true
        
        var trashAction = UIMutableUserNotificationAction()
        trashAction.identifier = "trashAction"
        trashAction.title = "Xoá"
        trashAction.activationMode = UIUserNotificationActivationMode.Background
        trashAction.destructive = true
        trashAction.authenticationRequired = true
        
        let actionsArray = NSArray(objects: justInformAction, modifyListAction, trashAction)
        let actionsArrayMinimal = NSArray(objects: trashAction, modifyListAction)
        
        // Specify the category related to the above actions.
        var injectListReminderCategory = UIMutableUserNotificationCategory()
        injectListReminderCategory.identifier = "injectListReminderCategory"
        injectListReminderCategory.setActions(actionsArray as [AnyObject], forContext: UIUserNotificationActionContext.Default)
        injectListReminderCategory.setActions(actionsArrayMinimal as [AnyObject], forContext: UIUserNotificationActionContext.Minimal)
        
        
        let categoriesForSettings = NSSet(objects: injectListReminderCategory)
        
        
        // Register the notification settings.
        let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as Set<NSObject>)
        UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        }
    }
    func scheduleNotification(userID:Int)->Int{
        dataManager.getInjectionBook(userID)
        dataManager.getUserInfo()
        dataManager.getSickInfo()
        var isDone = false
        println("e fs")
        var j = 0
        let today = NSDate()
        var data = NSData()
        var object = Dictionary<Int, UILocalNotification>()
        if (NSUserDefaults.standardUserDefaults().objectForKey("\(userID)") != nil)
        {
            println("test")
             data = NSUserDefaults.standardUserDefaults().objectForKey("\(userID)") as! NSData
             object = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Int: UILocalNotification]
            println(object.count)
            object.removeAll(keepCapacity: false)
        }
        
        for var i = 0 ; i < dataManager.injectData.count; i++
        {
            
            let date = dataManager.injectData[i].injectDate.dateByAddingTimeInterval(20)
            if dataManager.injectData[i].inactive == 0
            {
                
                let indexId = dataManager.injectData[i].sickID
                var sickName: String = dataManager.dictSickInfo[indexId]!
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                var daySubStr = dateFormatter.stringFromDate(dataManager.injectData[i].injectDate)
                if dataManager.injectData[i].injectDate.isGreaterThanDate(today)
                {
                    
                    var localNotification = UILocalNotification()
                    localNotification.fireDate = date
                    localNotification.alertBody = "Bé \(dataManager.userData[dataManager.userData.count - 1].userName) \(dataManager.injectData[i].injectDate.getDayOfWeekStr(daySubStr)) \(daySubStr)  tiêm  \(sickName)  mũi \(dataManager.injectData[i].number)"
                    localNotification.category = "injectListReminderCategory"
                    response[dataManager.injectData[i].id] = localNotification
                    NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(response), forKey: "\(userID)")
                    
                    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                    j++
                }
            }
            
        }
        return j
    }
}
