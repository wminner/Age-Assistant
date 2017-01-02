//
//  TagDetailViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 12/21/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import UIKit

protocol TagDetailViewControllerDelegate: class {
    func tagdetailViewController(_ controller: TagDetailViewController, didFinishEditingAgeWith tags: [String])
}

class TagDetailViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: TagDetailViewControllerDelegate?
    var tags: [String]?
    var allTags = [String]()
    var dataModel: DataModel!
    var currentlyEditing: IndexPath?    // IndexPath of the cell being edited (either via add or cell select)
    
    
    @IBAction func addNewTag() {
        // Force any edits in progress to stop
        tableView.endEditing(false)
        
        tableView.beginUpdates()
        // dataModel?.taglist.append("")
        allTags.append("")
        let indexPath = IndexPath(row: allTags.count-1, section: 0)
        currentlyEditing = indexPath
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        let textField = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as! UITextField
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }
    
//    func toggleTagChecked(for cell: UITableViewCell, at indexPath: IndexPath) {
//        let row = indexPath.row
//        let label = cell.viewWithTag(2) as! UILabel
//        
//        let checked = tagSelection[row]
//        if checked {
//            label.text = ""
//            tagSelection[row] = false
//        } else {
//            label.text = "√"
//            tagSelection[row] = true
//        }
//    }
    
    func sortTaglist() {
        allTags.sort(by: { tag1, tag2 in
            return tag1.localizedStandardCompare(tag2) == .orderedAscending })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allTags = dataModel.taglist
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Force any edits in progress to stop
        tableView.endEditing(false)
        
        if (self.isMovingFromParentViewController) {
            sortTaglist()
            // Copy allTags into dataModel
            dataModel.taglist = allTags
            delegate?.tagdetailViewController(self, didFinishEditingAgeWith: tags!)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let taglist = dataModel?.taglist {
//            return taglist.count
//        } else {
//            return 0
//        }
        return allTags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagTable", for: indexPath)
//        if let allTags = dataModel?.taglist {
//            let tag = allTags[indexPath.row]
//            let textField = cell.viewWithTag(1) as! UITextField
//            textField.text = tag
//            textField.delegate = self
//        }
        let tag = allTags[indexPath.row]
        let textField = cell.viewWithTag(1) as! UITextField
        textField.text = tag
        textField.delegate = self
        
        return cell
    }
    
    // Select cell (toggle checkmark)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            toggleTagChecked(for: cell, at: indexPath)
//        }
        // Force any edits in progress to stop
        tableView.endEditing(false)
        
        currentlyEditing = indexPath
        let textField = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as! UITextField
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Delete tag
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        allTags.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .none)
    }
    
    // TextField methods
    // TODO bug when user edits a tag in the middle to be empty string
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            // Delete the row discretely
            tableView.beginUpdates()
            // let indexPath = IndexPath(row: allTags.count-1, section: 0)
            allTags.remove(at: currentlyEditing!.row)
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
}
