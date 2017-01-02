//
//  AgeDetailViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/22/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import UIKit

protocol AgeDetailViewControllerDelegate: class {
    func ageDetailViewControllerDidCancel(_ controller: AgeDetailViewController)
    func ageDetailViewController(_ controller: AgeDetailViewController, didFinishAdding age: Age)
    func ageDetailViewController(_ controller: AgeDetailViewController, didFinishEditing age: Age)
}

class AgeDetailViewController: UITableViewController, UITextFieldDelegate, TagDetailViewControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dataModel: DataModel!
    var ageToEdit: Age?
    var date = Date()
    var taglist = [String]()
    var datePickerVisible = false
    weak var delegate: AgeDetailViewControllerDelegate?
    
    @IBAction func cancel() {
        delegate?.ageDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = ageToEdit {
            item.name = nameField.text!
            item.date = date
            let _ = item.updateAge()
            
            delegate?.ageDetailViewController(self, didFinishEditing: item)
        } else {
            let name = nameField.text!
            parseTags()
            let item = Age(name: name, date: date)
            for tag in taglist {
                item.addTag(tag)
            }
            
            delegate?.ageDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        date = datePicker.date
        updateDateLabel()
        updateAgeLabel()
    }
    
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if indexPath.section == 1 && indexPath.row == 1 {
//            return indexPath
//        } else {
//            return nil
//        }
//    }
    
    func tagdetailViewController(_ controller: TagDetailViewController, didFinishEditingAgeWith tags: [String]) {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 1 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datePickerVisible && section == 1 {
            return 2
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // print("request height at section \(indexPath.section), row \(indexPath.row)")
        if indexPath.section == 1 && indexPath.row == 1 {
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
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 1 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    func updateDateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = formatter.string(from: date)
        dateLabel.text = "\(formattedDate)"
    }
    
    func updateAgeLabel() {
        let age_update = Age.calculateAge(date)
        ageLabel.text = "Age: \(age_update)"
    }
    
    func parseTags() {
        // TODO
        // Parse tag field into an array of strings
    }
    
    func showDatePicker() {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = ageToEdit {
            title = "Edit Age"
            nameField.text = "\(item.name)"
            ageLabel.text = "Age: \(item.age)"
            
            // Date
            date = item.date
            updateDateLabel()

            // Tags
            var tagsString = ""
            for tag in item.tags {
                taglist.append(tag)
                tagsString += "\(tag), "
            }
            // Remove the trailing comma
            if tagsString != "" {
                tagsString = tagsString.substring(to: tagsString.index(tagsString.endIndex, offsetBy: -2))
            }
            tagsLabel.text = tagsString
        } else {
            updateDateLabel()
            tagsLabel.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditTagsSegue" {
            let controller = segue.destination as! TagDetailViewController
            controller.delegate = self
            if let tags = self.ageToEdit?.tags {
                controller.tags = Array(tags)
            }
            controller.dataModel = dataModel
        }
    }
}
