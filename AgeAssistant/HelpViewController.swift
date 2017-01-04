//
//  HelpViewController.swift
//  AgeAssistant
//
//  Created by Wesley Minner on 1/4/17.
//  Copyright © 2017 Wesley Minner. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentWidth: CGFloat = self.view.frame.width
        print(contentWidth)
        let contentHeight: CGFloat = 1000
        
        let contentVc = HelpContentViewController(nibName: "HelpContentViewController", bundle: nil)
        contentVc.view.frame = CGRect(x: 0, y: 0, width: contentWidth, height: contentHeight)
        self.addChildViewController(contentVc)
        self.scrollView.addSubview(contentVc.view)
        contentVc.didMove(toParentViewController: self)
        
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
}
