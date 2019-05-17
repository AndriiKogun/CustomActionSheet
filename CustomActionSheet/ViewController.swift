//
//  ViewController.swift
//  CustomActionSheet
//
//  Created by A K on 5/13/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var selectingDateLabel: UILabel!
    @IBOutlet weak var finalDateLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    
    
    var appearance: ActionSheetAppearance {
        let appearance = ActionSheetAppearance()
        appearance.backgroundColor = UIColor(red: 16/256, green: 32/256, blue: 50/256, alpha: 0.8)
        appearance.separatorColor = UIColor.clear
        appearance.selectionColor = UIColor(red: 5/256, green: 10/256, blue: 15/256, alpha: 1)
        appearance.textColor = UIColor(red: 31/256, green: 154/256, blue: 254/256, alpha: 1)
        
        appearance.headerColor = UIColor(red: 16/256, green: 32/256, blue: 50/256, alpha: 0.8)
        appearance.headerTitleColor = UIColor.lightGray
        appearance.headerMessageColor = UIColor.lightGray.withAlphaComponent(0.6)

        appearance.datePickerTextColor = UIColor.white
        
        return appearance
    }

    @IBAction func action(_ sender: Any) {
        let actionSheet = ActionSheet()
        actionSheet.appearance = appearance

        actionSheet.addHeaderWith(title: "Twitter.com", message: "Header message")
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
        let actionSheet = ActionSheet()
        actionSheet.appearance = appearance

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"

        actionSheet.addDatePicker { (date) in
            self.selectingDateLabel.text = dateFormatter.string(from: date)
        }
        
        actionSheet.addButonWith(title: "Search") {
            self.finalDateLabel.text = dateFormatter.string(from: actionSheet.date)
        }
        
        actionSheet.show(from: self)
    }
}

