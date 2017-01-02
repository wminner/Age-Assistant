//
//  TagDetailViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 12/21/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import UIKit

protocol TagDetailViewControllerDelegate: class {
    func tagdetailViewController(_ controller: TagDetailViewController, didFinishEditingAgeWith newtags: [String])
}

class TagDetailViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: TagDetailViewControllerDelegate?
    var tags = [String]()
    var tagSelection = [Bool]()
    var allTags = [String]()
    var dataModel: DataModel!
    var currentlyEditing: IndexPath?    // IndexPath of the cell being edited (either via add or cell select)
    
    
    @IBAction func addNewTag() {
        // Force any edits in progress to stop
        tableView.endEditing(false)
        
        tableView.beginUpdates()
        allTags.append("")
        tagSelection.append(true)
        let indexPath = IndexPath(row: allTags.count-1, section: 0)
        currentlyEditing = indexPath
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        let textField = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as! UITextField
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }
    
    func initializeTagSelection() {
        for tag in allTags {
            tags.contains(tag) ? tagSelection.append(true) : tagSelection.append(false)
        }
    }
    
    func toggleTagChecked(for cell: UITableViewCell, at indexPath: IndexPath) {
        let row = indexPath.row
        let label = cell.viewWithTag(2) as! UILabel
        
        let checked = tagSelection[row]
        if checked {
            label.text = ""
            tagSelection[row] = false
        } else {
            label.text = "√"
            tagSelection[row] = true
        }
    }
    
    func exportTags() {
        // Reset tags array to empty
        tags = [String]()
        // Grab each checked tag in allTags and put into tags array
        for (index, checked) in tagSelection.enumerated() {
            if checked {
                tags.append(allTags[index])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allTags = dataModel.taglist.sorted()
        initializeTagSelection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Force any edits in progress to stop
        tableView.endEditing(false)
        
        if (self.isMovingFromParentViewController) {
            // Copy allTags into dataModel
            dataModel.taglist = Set(allTags)
            // Find all checked tags and fill out tags array
            exportTags()
            
            delegate?.tagdetailViewController(self, didFinishEditingAgeWith: tags)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagTable", for: indexPath)
        let tag = allTags[indexPath.row]
        let check = tagSelection[indexPath.row]
        let textField = cell.viewWithTag(1) as! UITextField
        let checkField = cell.viewWithTag(2) as! UILabel
        textField.text = tag
        textField.delegate = self
        checkField.text = check ? "√" : ""
        
        return cell
    }
    
    // Select cell (toggle checkmark)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Force any edits in progress to stop
        tableView.endEditing(false)
        
        // Toggle checkmark on tag
        if let cell = tableView.cellForRow(at: indexPath) {
            toggleTagChecked(for: cell, at: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Delete tag
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        allTags.remove(at: indexPath.row)
        tagSelection.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .none)
    }
    
    // Tap accessory button to edit tag
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        currentlyEditing = indexPath
        let textField = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as! UITextField
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }
    
    // TextField methods
    // TODO bug when user edits a tag in the middle to be empty string
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            // Delete the row discretely
            tableView.beginUpdates()
            // let indexPath = IndexPath(row: allTags.count-1, section: 0)
            allTags.remove(at: currentlyEditing!.row)
            tagSelection.remove(at: currentlyEditing!.row)
            tableView.deleteRows(at: [currentlyEditing!], with: .none)
            tableView.endUpdates()
        } else {
            allTags[currentlyEditing!.row] = textField.text!
        }
        currentlyEditing = nil
        textField.isUserInteractionEnabled = false
        
    }
    
    // Prevent spaces in tags
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        } else {
            return true
        }
    }
    
    // End editing text field when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
