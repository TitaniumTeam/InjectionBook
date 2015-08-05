//
//  DateUtils.swift
//  iDoctors
//
//  Created by Valerio Ferrucci on 02/10/14.
//  Copyright (c) 2014 Tabasoft. All rights reserved.
//

import Foundation

extension NSDate {
    
    // -> Date System Formatted Medium
    func ToDateMediumString() -> NSString? {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.stringFromDate(self)
    }
    func getDayOfWeek(today:String)->Int {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    func getDayOfWeekStr(today:String)->String
    {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: todayDate)
        let dayOfWeekInt = myComponents.weekday
        
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
        return dayOfWeekStr
    }
    
    func isGreaterThanDate(dateToCompare: NSDate)->Bool{
        var isGreater = false
        var dateTo = self.dateByAddingTimeInterval(86400)
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending || dateTo.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate)->Bool{
        var isLess = false
        
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        
        return isLess
    }
    
}