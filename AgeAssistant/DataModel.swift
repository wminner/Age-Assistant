//
//  DataModel.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 12/18/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import Foundation

class DataModel {
    var agelist = [Age]()
    var taglist = Set<String>()
    
    var indexOfSelectedAge: Int {
        get {
            return UserDefaults.standard.integer(forKey: "AgeIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AgeIndex")
        }
    }
    
    init() {
        loadAgelist()
        loadTaglist()
        registerDefaults()
        print(documentsDirectory())
    }
    
    // Persistent storage helpers
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func ageFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Ages.plist")
    }
    
    func tagFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Tags.plist")
    }
    
    func saveAgelist() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(agelist, forKey: "Ages")
        archiver.finishEncoding()
        data.write(to: ageFilePath(), atomically: true)
    }
    
    func loadAgelist() {
        let path = ageFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            agelist = unarchiver.decodeObject(forKey: "Ages") as! [Age]
            unarchiver.finishDecoding()
            sortAgelist()
        }
    }
    
    func saveTaglist() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(taglist, forKey: "Tags")
        archiver.finishEncoding()
        data.write(to: tagFilePath(), atomically: true)
    }
    
    func loadTaglist() {
        let path = tagFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            taglist = unarchiver.decodeObject(forKey: "Tags") as! Set<String>
            unarchiver.finishDecoding()
        }
    }
    
    func registerDefaults() {
        let dictionary: [String: Any] = ["AgeIndex": -1,
                                         "AgeID": 0]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func sortAgelist() {
        agelist.sort(by: { age1, age2 in
            return age1.name.localizedStandardCompare(age2.name) == .orderedAscending })
    }
    
    class func nextAgeID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "AgeID")
        userDefaults.set(itemID + 1, forKey: "AgeID")
        userDefaults.synchronize()
        return itemID
    }
}
