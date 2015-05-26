//
//   swift
//  InjectionBook
//
//  Created by Tuan Anh on 5/16/15.
//  Copyright (c) 2015 Tuan Anh. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    var dataUser = [SQLRow]()
    let db = SQLiteDB.sharedInstance()
    
    var userInfo = UserInfo()
    var userData: [UserInfo] = []
    
    var sickInfo = SickInfo()
    var sickData: [SickInfo] = []
    
    var injectionScheduleInfo = InjectionScheduleInfo()
    var injectionScheduleData: [InjectionScheduleInfo] = []
    
    var injectSection = [Int]()
    var injectionName: [[Int]] = []
    
    var injectBook = InjectionBookInfo()
    var injectData: [InjectionBookInfo] = []
    
    var injectBookSection = [NSDate]()
    var injectBookINSection = [InjectionBookInfo]()
    var injectBookName: [[InjectionBookInfo]] = []
    
    var sickRegisterInfo = SickRegisterInfo()
    var sickRegisterData: [SickRegisterInfo] = []
    
    var dictUserGender = Dictionary<Int,Int>()
    
    var dictSickInfo = Dictionary<Int,String>()
    var dictSickInfoCode = Dictionary<Int,String>()
    var dictUserInfo = Dictionary<Int,String>()
    func getDataFromTable(tableName: String) -> [SQLRow]{
        var data = [SQLRow]()
        data = db.query("SELECT * FROM "+tableName)
        return data
    }
    func deleteUser(id :Int)
    {
        let sql = "DELETE FROM USER WHERE UserID="+"\(id)"
        let rc = db.execute(sql)
    }
    func getUserInfo()
    {
        userData = []
        var data = [SQLRow]()
        data = db.query("SELECT * FROM User")
        for var index = 0; index < data.count; index++
        {
            var row = data[index]
            if let userID = row["UserID"]
            {
                userInfo.userID = userID.asInt()
            }
            if let userBD = row["Birthday"]
            {
                userInfo.userBirthDay = userBD.asDate()!
            }
            if let userName = row["Name"]
            {
                userInfo.userName = userName.asString()
            }
            if let userGender = row["Gender"]
            {
                userInfo.gender = userGender.asInt()
            }
            dictUserInfo[userInfo.userID] = userInfo.userName as String
            dictUserGender[userInfo.userID] = userInfo.gender
            userData.append(userInfo)
            userInfo = UserInfo()
        }
    }
    func getSickInfo()
    {
        var data = [SQLRow]()
        data = db.query("SELECT * FROM Sick")
        for var index = 0; index < data.count; index++
        {
            var row = data[index]
            if let sickID = row["SickID"]
            {
                sickInfo.sickID = sickID.asInt()
            }
            if var sickName = row["SickName"]
            {
                sickInfo.sickName = sickName.asString()
            }
            if var sickDes = row["Description"]
            {
                sickInfo.sickdes = sickDes.asString()
            }
            if var sickCode = row["SickCode"]
            {
                sickInfo.sickCode = sickCode.asString()
            }
            dictSickInfo[sickInfo.sickID] =  sickInfo.sickName
            dictSickInfoCode[sickInfo.sickID] = sickInfo.sickCode
            sickData.append(sickInfo)
            sickInfo = SickInfo()
        }
       
    }
    func getInjectionSchedudleInfo()
    {
        injectionScheduleData = []
        var data = [SQLRow]()
        data = db.query("SELECT * FROM InjectionSchedule")
        for var index = 0; index < data.count; index++
        {
            let row = data[index]
            if let sickID = row["SickID"]
            {
                injectionScheduleInfo.sickID = sickID.asInt()
            }
            if let subMonth = row["Month"]
            {
                injectionScheduleInfo.subMoth = subMonth.asInt()
            }
            if let number = row["Number"]
            {
                injectionScheduleInfo.number = number.asInt()
            }
            injectionScheduleData.append(injectionScheduleInfo)
            injectionScheduleInfo = InjectionScheduleInfo()
        }
        
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 0
            {
                injectSection.append( injectionScheduleData[i].sickID)
                
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 2
            {
                injectSection.append(  injectionScheduleData[i].sickID)
               
               
            }
            
        }
        injectionName.append(injectSection)
        injectSection = [Int]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 3
            {
                injectSection.append(  injectionScheduleData[i].sickID)
                
                
            }
                  }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 4
            {
                injectSection.append(  injectionScheduleData[i].sickID)
                
            }
                    }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {   if   injectionScheduleData[i].subMoth == 6
        {
            injectSection.append(  injectionScheduleData[i].sickID)
                        }
        
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        { if   injectionScheduleData[i].subMoth == 7
        {
            injectSection.append(  injectionScheduleData[i].sickID)
                        }
                 }
        injectionName.append(injectSection)
        injectSection = [Int]()
        

        for var i = 0; i <  injectionScheduleData.count; i++
        { if   injectionScheduleData[i].subMoth == 9
        {
            injectSection.append(  injectionScheduleData[i].sickID)
                        }
                  }
        injectionName.append(injectSection)
        injectSection = [Int]()
        

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 12
            {
                injectSection.append(  injectionScheduleData[i].sickID)
                
            }
          
        }
        injectionName.append(injectSection)
        injectSection = [Int]()
        for var i = 0; i <  injectionScheduleData.count; i++
        { if   injectionScheduleData[i].subMoth == 15
        {
            injectSection.append(  injectionScheduleData[i].sickID)
                        }
               }
        injectionName.append(injectSection)
        injectSection = [Int]()
        

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 16
            {
                injectSection.append(  injectionScheduleData[i].sickID)
                
            }
          }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 18
            {
                injectSection.append(  injectionScheduleData[i].sickID)
                            }
    
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 19
            {
                injectSection.append(  injectionScheduleData[i].sickID)
                            }
   
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        { if   injectionScheduleData[i].subMoth == 24
        {
            injectSection.append(  injectionScheduleData[i].sickID)
           
            }

        }
        injectionName.append(injectSection)
        injectSection = [Int]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 31
            {
                injectSection.append(  injectionScheduleData[i].sickID)
                           }
  

        }
        injectionName.append(injectSection)
        injectSection = [Int]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 43
            {
                injectSection.append(  injectionScheduleData[i].sickID)
                          }
         }
        injectionName.append(injectSection)
        injectSection = [Int]()
        

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 60
            {
                injectSection.append(  injectionScheduleData[i].sickID)
               }
            
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 63            {
                injectSection.append(  injectionScheduleData[i].sickID)
                 }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 96
            {
                injectSection.append(  injectionScheduleData[i].sickID)
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 108
            {
                injectSection.append(  injectionScheduleData[i].sickID)
              }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 110
            {
                injectSection.append(  injectionScheduleData[i].sickID)
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 111
            {
                injectSection.append(  injectionScheduleData[i].sickID)
  
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 112
            {
                injectSection.append(  injectionScheduleData[i].sickID)
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 114
            {
                injectSection.append(  injectionScheduleData[i].sickID)
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 120
            {
                injectSection.append(  injectionScheduleData[i].sickID)
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 121
            {
                injectSection.append(  injectionScheduleData[i].sickID)
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 127
            {
                injectSection.append(  injectionScheduleData[i].sickID)
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 132
            {
                injectSection.append(  injectionScheduleData[i].sickID)
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 168
            {
                injectSection.append(  injectionScheduleData[i].sickID)
            }
        }
        injectionName.append(injectSection)
        injectSection = [Int]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 204
            {
                injectSection.append(  injectionScheduleData[i].sickID)
            }
            
            
        }
        injectionName.append(injectSection)
        injectSection = [Int]()


    }
    
    func getInjectionBook(id: Int)
    {
        injectData = []
        var data = [SQLRow]()
        data = db.query("SELECT * FROM InjectionBook WHERE UserID="+"\(id)")

        for var index = 0; index < data.count; index++
        {
            let row = data[index]
            let userID = row["UserID"]
                if let sickID = row["SickID"]
                {
                    injectBook.sickID = sickID.asInt()
                   
                }
                if let subMonth = row["InjectionDate"]
                {
                    injectBook.injectDate = subMonth.asDate()!
                }
                if let subMonth = row["InjectionNumber"]
                {
                    injectBook.number = subMonth.asString()
                }
                if let subMonth = row["IsInjection"]
                {
                    injectBook.isInjection = subMonth.asInt()
                }
                if let subMonth = row["Inactive"]
                {
                    injectBook.inactive = subMonth.asInt()
                }
                if let subMonth = row["Number"]
                {
                    injectBook.injectNumber = subMonth.asInt()
                     
                }
                if let subMonth = row["InjectionBookID"]
                {
                    injectBook.id = subMonth.asInt()
                     
                }
                if let subMonth = row["VaccineName"]
                {
                    injectBook.vaccineName = subMonth.asString()
                     
                }
                if let subMonth = row["Description"]
                {
                    injectBook.note = subMonth.asString()
                     
                }
                injectData.append(injectBook)
                injectBook = InjectionBookInfo()
        }
        
        for injectBookInfo in injectData
        {
            if injectBookInfo.inactive == 0
            {
                if injectBookInfo.sickID == 1
                {
                    
                }
            }
        }

    }

    func sortBySectionBook(injectionData: [InjectionBookInfo])
    {
        
        
        injectionScheduleData = []
        var data = [SQLRow]()
        data = db.query("SELECT * FROM InjectionSchedule")
    
        for var index = 0; index < data.count; index++
        {
            let row = data[index]
            if let sickID = row["SickID"]
            {
                injectionScheduleInfo.sickID = sickID.asInt()
            }
            if let subMonth = row["Month"]
            {
                injectionScheduleInfo.subMoth = subMonth.asInt()
            }
            if let number = row["Number"]
            {
                injectionScheduleInfo.number = number.asInt()
            }
            injectionScheduleData.append(injectionScheduleInfo)
            injectionScheduleInfo = InjectionScheduleInfo()
        }

        injectBookName = []
        
      for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 0
            {
                for var j = 0; j <  injectionData.count; j++
                {
                
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                    
                        }
                    }
                }
            }

        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 2
            {
            for var j = 0; j <  injectionData.count; j++
                {
                
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                        
                        }
                    }
                }
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 3
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 4
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 6
            {
                for var j = 0; j <  injectionData.count; j++
                {
                
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                        
                        }
                    }
                }
            
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()

        
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 7
            {
                for var j = 0; j <  injectionData.count; j++
                {
                
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                        
                        }
                    }
                }
            
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 9
            {
                for var j = 0; j <  injectionData.count; j++
                {
                
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                        
                        }
                    }
                }
            
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 12
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 15
            {
                for var j = 0; j <  injectionData.count; j++
                {
                
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                        
                        }
                    }
                }
            
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 16
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 18
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 19
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 24
            {
                
                    for var j = 0; j <  injectionData.count; j++
                    {
                    
                        if injectionData[j].sickID == injectionScheduleData[i].sickID
                        {
                            if injectionScheduleData[i].number == injectionData[j].injectNumber
                            {
                                injectBookINSection.append(injectionData[j])
                            
                            }
                        }
                    }
            
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 31
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 43
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
            
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 60
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
            
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 63            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 96
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
            
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 108
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
            
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 110
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
            
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 111
            { for var j = 0; j <  injectionData.count; j++
            {
                
                if injectionData[j].sickID == injectionScheduleData[i].sickID
                {
                    if injectionScheduleData[i].number == injectionData[j].injectNumber
                    {
                        injectBookINSection.append(injectionData[j])
                        
                    }
                }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()

        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 112
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 114
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 120
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 121
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 127
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 132
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 168
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()
        for var i = 0; i <  injectionScheduleData.count; i++
        {
            if   injectionScheduleData[i].subMoth == 204
            {
                for var j = 0; j <  injectionData.count; j++
                {
                    
                    if injectionData[j].sickID == injectionScheduleData[i].sickID
                    {
                        if injectionScheduleData[i].number == injectionData[j].injectNumber
                        {
                            injectBookINSection.append(injectionData[j])
                            
                        }
                    }
                }
                
            }
            
        }
        if injectBookINSection.count > 0 { injectBookName.append(injectBookINSection)}
        injectBookINSection = [InjectionBookInfo]()

    }
    
    func getSickRegisterInfo(id: Int)
    {
        sickRegisterData = []
        var data = [SQLRow]()
        data = db.query("SELECT * FROM SickRegister WHERE UserID=\(id)")
        
        for var index = 0; index < data.count; index++
        {
            var row = data[index]
            if let userID = row["UserID"]
            {
                sickRegisterInfo.userID = userID.asInt()
            }
            if let sickID = row["SickID"]
            {
                sickRegisterInfo.sickID = sickID.asInt()
            }
            if let isSelected = row["Selected"]
            {
                sickRegisterInfo.isSelected = isSelected.asInt()
                if isSelected.asInt() == 0
                {
                    sickRegisterInfo.boolSelected = false
                }
                else
                {
                    sickRegisterInfo.boolSelected = true
                }
            }
            if let isEnable = row["Enable"]
            {
                sickRegisterInfo.isEnable = isEnable.asInt()
            }
            sickRegisterData.append(sickRegisterInfo)
            sickRegisterInfo = SickRegisterInfo()
        }

    }
    func getReportAllInSection(sickID: [Int], id: Int)
    {
        getInjectionBook(id)
        getSickInfo()
        var injectBookINSection = [InjectionBookInfo]()
        injectBookName = []
        for var i = 0 ; i < sickID.count ; i++
        {
            for var j = 0; j < injectData.count; j++
            {
                if sickID[i] == injectData[j].sickID
                {
                    injectBookINSection.append(injectData[j])
                }
            }
            injectBookName.append(injectBookINSection)
            injectBookINSection = []
        }

    }

}
