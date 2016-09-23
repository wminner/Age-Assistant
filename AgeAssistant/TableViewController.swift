//
//  TableViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/22/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var ageObjects = [Age]()
    var selectedRow: Int = 0
    
    // Cell dictionarys for the table
//    var nameDict: [Int: String] = [0: "Wesley Minner"]
//    var ageDict: [Int: Int] = [0: 0]
//    var dateDict: [Int: Date] = [0: Date(dateString: "1989-08-06")]
//    var tagsDict: [Int: String] = [0: "myself"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Age objects from stable storage
        // TODO
        
        // Add an entry to the Age object's list for testing
        let mybirthday = makeDate(year: 1989, month: 8, day: 6)
        let myage = Age(name: "Wesley Minner", date: mybirthday!, tags: ["myself", "dog"])
        ageObjects.append(myage)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ageObjects.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTable", for: indexPath)

        // Configure the cell...
        let name = cell.viewWithTag(1) as! UILabel
        let age = cell.viewWithTag(2) as! UILabel
        let date = cell.viewWithTag(3) as! UILabel
        let tags = cell.viewWithTag(4) as! UILabel
        let ageObj = ageObjects[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: ageObj.date)
        
        name.text = "Name: \(ageObj.name)"
        age.text = "Age: \(ageObj.age)"
        date.text = "Date: \(formattedDate)"
        
        var tagsString = "Tags:"
        for tag in ageObj.tags {
            tagsString += " \(tag),"
        }
        // Remove the trailing comma
        tagsString.remove(at: tagsString.index(before: tagsString.endIndex))
        tags.text = tagsString

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "detailSegue") {
            let detailVc = segue.destination as! DetailViewController
            let selectedAgeObj = ageObjects[self.selectedRow]
            
            detailVc.ageObj = selectedAgeObj
        }
    }
 
}
