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
    func isGreaterThanDate(dateToCompare: NSDate)->Bool{
        var isGreater = false
        
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending || self.isEqualToDate(dateToCompare)
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