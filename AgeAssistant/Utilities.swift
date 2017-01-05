//
//  Utilities.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/22/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import Foundation

// Make a date from year, month, and day
func makeDate(year: Int, month: Int, day: Int) -> Date? {
    var comp = DateComponents()
    
    comp.year = year
    comp.month = month
    comp.day = day
    
    let date = Calendar.current.date(from: comp)
    return date
}

func roundDateToClosestYear(date: Date) -> Date {
    let today = Date()
    let currYear = Calendar.current.component(.year, from: today)
    var comp = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
    comp.year = currYear
    
    var newdate = Calendar.current.date(from: comp)!
    if newdate < today {
        comp.year = currYear + 1
        newdate = Calendar.current.date(from: comp)!
    }
    return newdate
}

func addYearsToDate(date: Date, years: Int) -> Date {
    var comp = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
    comp.year = comp.year! + years
    
    let newdate = Calendar.current.date(from: comp)!
    return newdate
}

func getMonthString(month: Int) -> String {
    let dict = [
        1: "january",
        2: "february",
        3: "march",
        4: "april",
        5: "may",
        6: "june",
        7: "july",
        8: "august",
        9: "september",
        10: "october",
        11: "november",
        12: "december"
    ]
    if let res = dict[month] {
        return res
    } else {
        return ""
    }
}
