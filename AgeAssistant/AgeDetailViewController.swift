//
//  AgeDetailViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/22/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import UIKit
import UserNotifications

protocol AgeDetailViewControllerDelegate: class {
    func ageDetailViewControllerDidCancel(_ controller: AgeDetailViewController)
    func ageDetailViewController(_ controller: AgeDetailViewController, didFinishAdding age: Age, editedTags editTags: [(start:String, end:String)], deletedTags delTags: [String])
    func ageDetailViewController(_ controller: AgeDetailViewController, didFinishEditing age: Age, editedTags editTags: [(start:String, end:String)], deletedTags delTags: [String])
}

class AgeDetailViewController: UITableViewController, UITextFieldDelegate, TagDetailViewControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remindDatePickerCell: UITableViewCell!
    @IBOutlet weak var remindDatePicker: UIDatePicker!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var remindDateLabel: UILabel!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var dataModel: DataModel!
    var ageToEdit: Age?
    var date = Date()
    var tags = Set<String>()
    var datePickerVisible = false
    var remindDatePickerVisible = false
    var editTags = [(start:String, end:String)]()
    var delTags = [String]()
    weak var delegate: AgeDetailViewControllerDelegate?
    
    var remindDate = Date()
    
    
    @IBAction func cancel() {
        delegate?.ageDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        // Edit age object
        if let item = ageToEdit {
            item.name = nameField.text!
            item.date = date
            let _ = item.updateAge()
            
            item.clearTags()
            for tag in tags {
                item.addTag(tag)
            }
            item.shouldRemind = shouldRemindSwitch.isOn
            item.remindDate = remindDate
            item.scheduleNotification()
            
            delegate?.ageDetailViewController(self, didFinishEditing: item, editedTags: editTags, deletedTags: delTags)
        
        // Create new age object
        } else {
            let name = nameField.text!
            let item = Age(name: name, date: date, tags: Array(tags))
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.remindDate = remindDate
            item.scheduleNotification()
            
            delegate?.ageDetailViewController(self, didFinishAdding: item, editedTags: editTags, deletedTags: delTags)
        }
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        // date = setDateTime(toHour: 0, toMinute: 0, date: datePicker.date)
        date = datePicker.date
        updateDateLabel()
        updateAgeLabel()
    }
    
    @IBAction func remindDateChanged(_ remindDatePicker: UIDatePicker) {
        remindDate = remindDatePicker.date
        updateRemindDateLabel()
    }
    
    // Prompt user for notification permissions the first time they flip a reminder switch on
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        nameField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in /* do nothing */
            }
            
            // Set remind date to birthday, at noon, if this is a new age profile
            if ageToEdit == nil {
                let defaultRemindDate = roundDateToClosestYear(date: date)
                remindDate = setDateTime(toHour: 12, toMinute: 0, date: defaultRemindDate)
                updateRemindDateLabel()
            }
        }
    }
    
    func tagdetailViewController(_ controller: TagDetailViewController, didFinishEditingAgeWith newTags: [String], editedTags editTags: [(start:String, end:String)], deletedTags delTags: [String]) {
        self.tags = Set(newTags)
        self.editTags = editTags
        self.delTags = delTags
        updateTagsLabel()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 1 {
            return datePickerCell
        } else if indexPath.section == 3 && indexPath.row == 2 {
            return remindDatePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datePickerVisible && section == 1 {
            return 2
        } else if remindDatePickerVisible && section == 3 {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            return 217
        } else if indexPath.section == 3 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        nameField.resignFirstResponder()
        
        // Date cell located at section 1, row 0
        if indexPath.section == 1 && indexPath.row == 0 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        } else if indexPath.section == 3 && indexPath.row == 1 {
            if !remindDatePickerVisible {
                showRemindDatePicker()
            } else {
                hideRemindDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 1 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        } else if indexPath.section == 3 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 1, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    func updateDateLabel() {
        let formatter = DateFormatter()
        // formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = "MMM d, yyyy"
        dateLabel.text = formatter.string(from: date)
    }
    
    func updateRemindDateLabel() {
        let formatter = DateFormatter()
        // formatter.dateStyle = .short
        // formatter.timeStyle = .short
        formatter.dateFormat = "MMM d, yyyy; h:mm a"
        remindDateLabel.text = formatter.string(from: remindDate)
    }
    
    func updateAgeLabel() {
        let age_update = Age.calculateAge(date)
        ageLabel.text = "Age: \(age_update)"
    }
    
    func updateTagsLabel() {
        tagsLabel.text = Age.formTagsString(tags)
    }
    
    func showDatePicker() {
        hideRemindDatePicker()
        datePickerVisible = true
        
        let indexPathDateRow = IndexPath(row: 0, section: 1)
        let indexPathDatePicker = IndexPath(row: 1, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(date, animated: false)
    }
    
    func showRemindDatePicker() {
        hideDatePicker()
        remindDatePickerVisible = true
        
        let indexPathRemindDateRow = IndexPath(row: 1, section: 3)
        let indexPathRemindDatePicker = IndexPath(row: 2, section: 3)
        
        if let remindDateCell = tableView.cellForRow(at: indexPathRemindDateRow) {
            remindDateCell.detailTextLabel!.textColor = remindDateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathRemindDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathRemindDateRow], with: .none)
        tableView.endUpdates()
        
        remindDatePicker.setDate(remindDate, animated: false)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 0, section: 1)
            let indexPathDatePicker = IndexPath(row: 1, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func hideRemindDatePicker() {
        if remindDatePickerVisible {
            remindDatePickerVisible = false
            
            let indexPathRemindDateRow = IndexPath(row: 1, section: 3)
            let indexPathRemindDatePicker = IndexPath(row: 2, section: 3)
            
            if let cell = tableView.cellForRow(at: indexPathRemindDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathRemindDateRow], with: .none)
            tableView.deleteRows(at: [indexPathRemindDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = ageToEdit {
            title = "Edit Age"
            nameField.text = "\(item.name)"
            nameField.delegate = self
            ageLabel.text = "Age: \(item.age)"
            
            // Date
            date = item.date
            updateDateLabel()

            // Tags
            tags = item.tags
            tagsLabel.text = Age.formTagsString(tags)
            
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            remindDate = item.remindDate
            
        } else {
            updateDateLabel()
            tagsLabel.text = ""
            nameField.becomeFirstResponder()
            nameField.delegate = self
            remindDate = setDateTime(toHour: 12, toMinute: 0, date: remindDate)
        }
        
        updateRemindDateLabel()
        let today = Date()
        remindDatePicker.minimumDate = today
        remindDatePicker.maximumDate = addYearsToDate(date: today, years: 1)
        remindDatePicker.minuteInterval = 5
        
        // datePicker.timeZone = TimeZone(abbreviation: "GMT")
    }
    
    // End editing text field when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
        hideRemindDatePicker()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditTagsSegue" {
            let controller = segue.destination as! TagDetailViewController
            controller.delegate = self
            controller.tags = Array(tags)
            controller.dataModel = dataModel
        }
    }
}
