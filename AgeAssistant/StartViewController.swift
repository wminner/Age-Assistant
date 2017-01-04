//
//  StartViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 9/4/16.
//  Copyright © 2016 Wesley Minner. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var dataModel: DataModel!
    
    @IBOutlet weak var startButton: UIButton!
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            startButton.setTitle("Get Started", for: UIControlState.normal)
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleFirstTime()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartSegue" {
            let controller = segue.destination as! AgeListViewController            
            controller.dataModel = dataModel
            dataModel.sortAgelist()
        }
    }
}

