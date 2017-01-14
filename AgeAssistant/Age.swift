//
//  Age.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/22/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import Foundation
import UserNotifications

// Class to keep track of something's age
class Age: NSObject, NSCoding {
    var name = ""
    var date: Date = Date()
    var age: Int = 0
    var tags = Set<String>()
    var ageID: Int
    
    var remindDate = Date()
    var shouldRemind = false
    
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
        
        remindDate = aDecoder.decodeObject(forKey: "RemindDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        
        super.init()
    }
    
    deinit {
        removeNotification()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(date, forKey: "Date")
        aCoder.encode(age, forKey: "Age")
        aCoder.encode(tags, forKey: "Tags")
        aCoder.encode(ageID, forKey: "AgeID")
        
        aCoder.encode(remindDate, forKey: "RemindDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
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
        self.age = age_result
        
        return true
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
        if self.tags.remove(tag) != nil {
            return true
        } else {
            return false
        }
    }
    
    func clearTags() {
        self.tags = Set<String>()
    }
    
    // User does not know year they are scheduling using date picker
    // Schedule notification at most 1 year in the future (or edit year to satisfy this condition)
    func scheduleNotification() {
        removeNotification()
        if shouldRemind {
            // Set remindDate to be at most 1 year from now
            // remindDate = roundDateToClosestYear(date: remindDate)
            
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = "Important day for \(name)"
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: remindDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "\(ageID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled notification \(request) for ageID \(ageID)")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(ageID)"])
    }
    
    
    // Static method to calculate age in years from given date
    class func calculateAge(_ fromDate: Date) -> Int {
        // print("fromDate = \(fromDate)")
        // print("today = \(Date())")
        
        let dateComp = Calendar.current.dateComponents([.year], from: fromDate, to: Date())
        return dateComp.year!
    }
    
    // Pass in array of tags to get formatted tagsString
    class func formTagsString(_ tagSet: Set<String>) -> String {
        var tagsString = ""
        if tagSet.count != 0 {
            for tag in tagSet.sorted() {
                tagsString += "\(tag), "
            }
            // Remove trailing comma and space
            tagsString = tagsString.substring(to: tagsString.index(tagsString.endIndex, offsetBy: -2))
        }
        return tagsString
    }
}
