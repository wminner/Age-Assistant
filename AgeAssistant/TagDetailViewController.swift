//
//  TagDetailViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 12/21/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import UIKit

protocol TagDetailViewControllerDelegate: class {
    func tagdetailViewController(_ controller: TagDetailViewController, didFinishEditing age: Age)
}

class TagDetailViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: TagDetailViewControllerDelegate?
    var tags: [String]?
    
    @IBAction func addNewTag() {
        tableView.endEditing(false)
        
        tableView.beginUpdates()
        tags?.append("")
        let indexPath = IndexPath(row: tags!.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        let textField = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as! UITextField
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let taglist = tags {
            return taglist.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagTable", for: indexPath)
        if let taglist = tags {
            let tag = taglist[indexPath.row]
            let textField = cell.viewWithTag(1) as! UITextField
            textField.text = tag
            textField.delegate = self
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Delete tag
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tags?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .none)
    }
    
    // TextField methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            // Delete the row discretely
            tableView.beginUpdates()
            let indexPath = IndexPath(row: tags!.count-1, section: 0)
            tags?.remove(at: tags!.endIndex-1)
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
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
