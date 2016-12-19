//
//  AgeListViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/22/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import UIKit

class AgeListViewController: UITableViewController, AgeDetailViewControllerDelegate {
    var dataModel: DataModel!
    
    func ageDetailViewControllerDidCancel(_ controller: AgeDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func ageDetailViewController(_ controller: AgeDetailViewController, didFinishAdding age: Age) {
        // Insert new age into list and sort list
        dataModel.agelist.append(age)
        dataModel.sortAgelist()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func ageDetailViewController(_ controller: AgeDetailViewController, didFinishEditing age: Age) {
        // Update the entry in table and re-sort list
        dataModel.sortAgelist()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add an entry to the Age object's list for testing
//        let mybirthday = makeDate(year: 1989, month: 8, day: 6)
//        let myage = Age(name: "Wesley Minner", date: mybirthday!, tags: ["myself", "dog"])
//        dataModel.agelist.append(myage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.agelist.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTable", for: indexPath)

        // Configure the cell...
        cell.accessoryType = .detailDisclosureButton
        let name = cell.viewWithTag(1) as! UILabel
        let age = cell.viewWithTag(2) as! UILabel
        let date = cell.viewWithTag(3) as! UILabel
        let tags = cell.viewWithTag(4) as! UILabel
        let ageObj = dataModel.agelist[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = dateFormatter.string(from: ageObj.date)
        
        name.text = "\(ageObj.name)"
        age.text = "Age: \(ageObj.age)"
        date.text = "Date: \(formattedDate)"
        
        var tagsString = "Tags:"
        for tag in ageObj.tags {
            tagsString += " \(tag),"
        }
        // Remove the trailing comma
        if ageObj.tags.count != 0 {
            tagsString.remove(at: tagsString.index(before: tagsString.endIndex))
        }
        tags.text = tagsString

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "EditAgeSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Edit Age Item
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditAgeSegue", sender: indexPath)
    }
    
    // Delete Age item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.agelist.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAgeSegue" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AgeDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditAgeSegue" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AgeDetailViewController
            
            controller.delegate = self
            if let indexPath = sender as? IndexPath {
                controller.ageToEdit = dataModel.agelist[indexPath.row]
            }
        }
    }
}
