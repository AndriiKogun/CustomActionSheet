//
//  ViewController.swift
//  CustomActionSheet
//
//  Created by A K on 5/13/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    

    @IBAction func action(_ sender: Any) {
        let actionSheet = ActionSheet()
        actionSheet.backgroundColor = UIColor(red: 16/256, green: 32/256, blue: 50/256, alpha: 0.8)
        actionSheet.separatorColor = UIColor.clear
        actionSheet.selectionColor = UIColor(red: 5/256, green: 10/256, blue: 15/256, alpha: 1)
        actionSheet.textColor = UIColor(red: 31/256, green: 154/256, blue: 254/256, alpha: 1)

        actionSheet.headerColor = UIColor(red: 16/256, green: 32/256, blue: 50/256, alpha: 0.8)
        actionSheet.headerTextColor = UIColor.lightGray
        actionSheet.headerText = "Twitter.com"
        actionSheet.headerMessage = "Header message"
        
        actionSheet.addButonWith(icon: UIImage(named: "1")!, title: "Open in...") {
            self.actionLabel.text = "Open in..."
        }
        
        actionSheet.addButonWith(icon: UIImage(named: "2")!, title: "Copy Link") {
            self.actionLabel.text = "Copy Link"
        }

        actionSheet.addButonWith(title: "Add to Reading List") {
            self.actionLabel.text = "Add to Reading List"
        }
        
        actionSheet.didDismissBlock = {
            
        }

        actionSheet.show(from: self)
    }
    
    @IBAction func dateAction(_ sender: Any) {
        
    }
}

