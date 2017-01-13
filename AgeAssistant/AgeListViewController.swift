//
//  AgeListViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/22/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import UIKit

extension AgeListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

class AgeListViewController: UITableViewController, AgeDetailViewControllerDelegate {
    var dataModel: DataModel!
    var filteredAges = [Age]()
    let searchController = UISearchController(searchResultsController: nil)
    
    deinit {
        // Needed to prevent warning about searchController causing undefined behavior if trying to load view while parent is deallocating
        searchController.removeFromParentViewController()
    }
    
    func ageDetailViewControllerDidCancel(_ controller: AgeDetailViewController) {
        // Dismiss the searchController if necessary
        if searchController.isActive {
            dismiss(animated: false, completion: nil)
        }
        // Then dismiss the popup
        dismiss(animated: true, completion: nil)
    }
    
    func ageDetailViewController(_ controller: AgeDetailViewController, didFinishAdding age: Age, editedTags editTags: [(start:String, end:String)], deletedTags delTags: [String]) {
        // Insert new age into list and sort list
        dataModel.agelist.append(age)
        dataModel.sortAgelist()
        // Update and delete tags
        cleanUp(editedTags: editTags)
        cleanUp(deletedTags: delTags)
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func ageDetailViewController(_ controller: AgeDetailViewController, didFinishEditing age: Age, editedTags editTags: [(start:String, end:String)], deletedTags delTags: [String]) {
        // Update the entry in table and re-sort list
        dataModel.sortAgelist()
        // Update and delete tags
        cleanUp(editedTags: editTags)
        cleanUp(deletedTags: delTags)
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // Search filter method
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredAges = dataModel.agelist.filter { age in
            let filteredTags = age.tags.filter { (tag: String) -> Bool in
                let stringMatch = tag.lowercased().range(of: searchText.lowercased())
                return stringMatch != nil ? true : false
            }
            let birthMonth = Calendar.current.component(.month, from: age.date)
            let birthYear = Calendar.current.component(.year, from: age.date)
            let birthMonthString = getMonthString(month: birthMonth)
            return age.name.lowercased().contains(searchText.lowercased()) || !filteredTags.isEmpty || String(age.age).contains(searchText.lowercased()) || birthMonthString.contains(searchText.lowercased()) || String(birthYear).contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    // Always call this before cleanUpDeletedTags, in case user edits before finally deleting tag
    func cleanUp(editedTags editTags: [(start:String, end:String)]) {
        for age in dataModel.agelist {
            for (startTag, endTag) in editTags {
                if age.tags.remove(startTag) != nil {
                    age.tags.insert(endTag)
                }
            }
        }
    }
    
    // Delete tags from all Age objects that were deleted from the main taglist
    func cleanUp(deletedTags delTags: [String]) {
        for age in dataModel.agelist {
            for tag in delTags {
                let _ = age.tags.remove(tag)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text != "" {
            return filteredAges.count
        }
        return dataModel.agelist.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTable", for: indexPath)

        // Configure the cell...
        // cell.accessoryType = .detailDisclosureButton
        let name = cell.viewWithTag(1) as! UILabel
        let age = cell.viewWithTag(2) as! UILabel
        let date = cell.viewWithTag(3) as! UILabel
        let tags = cell.viewWithTag(4) as! UILabel
        
        let ageObj: Age
        if searchController.searchBar.text != "" {
            ageObj = self.filteredAges[indexPath.row]
        } else {
            ageObj = dataModel.agelist[indexPath.row]
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = dateFormatter.string(from: ageObj.date)
        
        name.text = "\(ageObj.name)"
        age.text = "Age: \(ageObj.age)"
        date.text = "Date: \(formattedDate)"
        
        let tagsString = "Tags: "
        tags.text = tagsString + Age.formTagsString(ageObj.tags)

        return cell
    }
    
    // Edit Item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "EditAgeSegue", sender: indexPath)
    }
    
    // Delete item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.agelist.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAgeSegue" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AgeDetailViewController
            
            controller.delegate = self
            controller.dataModel = dataModel
        } else if segue.identifier == "EditAgeSegue" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AgeDetailViewController
            
            controller.delegate = self
            controller.dataModel = dataModel
            if let indexPath = sender as? IndexPath {
                if searchController.searchBar.text != "" {
                    controller.ageToEdit = self.filteredAges[indexPath.row]
                } else {
                    controller.ageToEdit = dataModel.agelist[indexPath.row]
                }
            }
        }
    }
}
