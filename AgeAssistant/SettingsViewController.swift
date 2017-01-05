//
//  SettingsViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 1/4/17.
//  Copyright © 2017 Wesley Minner. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var nameCheckLabel: UILabel!
    @IBOutlet weak var ageCheckLabel: UILabel!
    @IBOutlet weak var monthCheckLabel: UILabel!
    @IBOutlet weak var ascendCheckLabel: UILabel!
    @IBOutlet weak var descendCheckLabel: UILabel!
    
    // Check settings as dictated by user defaults
    func initializeSettingSelection() {
        let userDefaults = UserDefaults.standard
        let sortBy = userDefaults.string(forKey: "SortBy")
        let orderBy = userDefaults.string(forKey: "OrderBy")
        
        checkmarkSetting(sortBy!)
        checkmarkSetting(orderBy!)
    }
    
    // Helper to ensure each section has a mutually exclusive setting checkmarked
    func checkmarkSetting(_ setting: String) {
        switch setting {
        case "Name":
            nameCheckLabel.text = "√"
            ageCheckLabel.text = ""
            monthCheckLabel.text = ""
        case "Age":
            nameCheckLabel.text = ""
            ageCheckLabel.text = "√"
            monthCheckLabel.text = ""
        case "Month":
            nameCheckLabel.text = ""
            ageCheckLabel.text = ""
            monthCheckLabel.text = "√"
        case "Ascending":
            ascendCheckLabel.text = "√"
            descendCheckLabel.text = ""
        case "Descending":
            ascendCheckLabel.text = ""
            descendCheckLabel.text = "√"
        default: // Should never happen
            print("Invalid setting")
        }
    }
    
    // Helper to actually set the setting value in UserDefaults
    func setSetting(_ setting: String) {
        let userDefaults = UserDefaults.standard
        switch setting {
        case "Name", "Age", "Month":
            userDefaults.set(setting, forKey: "SortBy")
        case "Ascending", "Descending":
            userDefaults.set(setting, forKey: "OrderBy")
        default: // Should never happen
            print("Invalid setting")
        }
        userDefaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettingSelection()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 3
        } else { // section == 1
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Use the label text as easy way to determine what setting user selected
        let cell = tableView.cellForRow(at: indexPath)
        let setting = (cell?.viewWithTag(1001) as! UILabel).text!
        checkmarkSetting(setting)
        setSetting(setting)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
