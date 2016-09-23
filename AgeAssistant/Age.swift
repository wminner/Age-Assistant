//
//  Age.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/22/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import Foundation

// Class to keep track of something's age
class Age {
    var name: String
    var date: Date
    var age: Int
    var tags: [String]
    
    init(name: String, date: Date, tags: [String]) {
        self.name = name
        self.date = date
        self.tags = tags
        self.age = 0
        
        if !calculateAge(date) {
            print("Error: date not valid!")
        }
    }
    
    // Use the date given to calculate object's age
    // Returns true if age is greater than zero, otherwise false
    func calculateAge(_ fromDate: Date?) -> Bool {
        let date: Date
        let calendar: Calendar = Calendar.current
        
        // Check optional for nil
        if fromDate == nil {
            date = self.date
        } else {
            date = fromDate!
        }
        
        // Calculate the age and assign it if valid
        let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
        if ageComponents.year! >= 0 {
            self.age = ageComponents.year!
            print("Assigning age of \(self.name) to \(self.age).")
            return true
        } else {
            return false
        }
    }
    
    // Add a tag to object if valid and not already there
    // Returns true if successful, otherwise false
    func addTag(tag: String) -> Bool {
        return true
    }
    
    // Remove a tag from the object
    // Returns true if tag was found and removed, otherwise false
    func removeTag(tag: String) -> Bool {
        return true
    }
}
