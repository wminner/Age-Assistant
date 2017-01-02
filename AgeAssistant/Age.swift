//
//  Age.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/22/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import Foundation

// Class to keep track of something's age
class Age: NSObject, NSCoding {
    var name = ""
    var date: Date = Date()
    var age: Int = 0
    var tags = Set<String>()
    var ageID: Int
    
    override init() {
        ageID = DataModel.nextAgeID()
        super.init()
    }
    
    convenience init(name: String, date: Date) {
        self.init(name: name, date: date, tags: [])
    }
    
    init(name: String, date: Date, tags: [String]) {
        self.name = name
        self.date = date
        self.tags = Set(tags)
        self.ageID = DataModel.nextAgeID()
        
        super.init()
        
        if !updateAge(date) {
            print("Error: date not valid!")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        date = aDecoder.decodeObject(forKey: "Date") as! Date
        age = aDecoder.decodeInteger(forKey: "Age")
        tags = aDecoder.decodeObject(forKey: "Tags") as! Set<String>
        ageID = aDecoder.decodeInteger(forKey: "AgeID")
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(date, forKey: "Date")
        aCoder.encode(age, forKey: "Age")
        aCoder.encode(tags, forKey: "Tags")
        aCoder.encode(ageID, forKey: "AgeID")
    }
    
    // Use the date given to calculate object's age
    // Returns true if age is greater than zero, otherwise false
    func updateAge(_ fromDate: Date?) -> Bool {
        let date: Date
        
        // Check optional for nil
        if fromDate == nil {
            date = self.date
        } else {
            date = fromDate!
        }
        
        // Calculate the age and assign it if valid
        let age_result = Age.calculateAge(date)
        if age_result >= 0 {
            self.age = age_result
            print("Assigning age of \(self.name) to \(self.age).")
            return true
        } else {
            return false
        }
    }
    
    // For convenience
    func updateAge() -> Bool {
        return updateAge(nil)
    }
    
    // Add a tag to object
    func addTag(_ tag: String) {
        self.tags.insert(tag)
    }
    
    // Remove a tag from the object
    // Returns true if tag was found and removed, otherwise false
    func removeTag(_ tag: String) -> Bool {
        if let _ = self.tags.remove(tag) {
            return true
        } else {
            return false
        }
    }
    
    func clearTags() {
        self.tags = Set<String>()
    }
    
    // Static method to calculate age in years from given date
    class func calculateAge(_ fromDate: Date) -> Int {
        let calendar: Calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: fromDate, to: Date())
        return ageComponents.year!
    }
    
    // Pass in array of tags to get formatted tagsString
    class func formTagsString(_ tagArray: [String]) -> String {
        var tagsString = ""
        if tagArray.count != 0 {
            for tag in tagArray {
                tagsString += "\(tag), "
            }
            // Remove trailing comma and space
            tagsString = tagsString.substring(to: tagsString.index(tagsString.endIndex, offsetBy: -2))
        }
        return tagsString
    }
}
