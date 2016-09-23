//
//  DetailViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/22/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    @IBAction func pressBackButton() {
        self.navigationController!.popViewController(animated: true)
    }
    
    var ageObj: Age? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ageObj != nil {
            nameLabel.text = "\(ageObj!.name)"
            ageLabel.text = "Age: \(ageObj!.age)"
            
            // Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = dateFormatter.string(from: ageObj!.date)
            dateLabel.text = "Date: \(formattedDate)"

            // Tags
            var tagsString = "Tags:"
            for tag in ageObj!.tags {
                tagsString += " \(tag),"
            }
            // Remove the trailing comma
            tagsString.remove(at: tagsString.index(before: tagsString.endIndex))
            tagsLabel.text = tagsString
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
