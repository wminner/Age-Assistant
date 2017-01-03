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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartSegue" {
            let controller = segue.destination as! AgeListViewController            
            controller.dataModel = dataModel
        }
    }
}

