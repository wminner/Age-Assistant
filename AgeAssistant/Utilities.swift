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
