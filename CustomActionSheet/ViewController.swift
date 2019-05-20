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
    
    var date = Date()
    
    var appearance: ActionSheetAppearance {
        var appearance = ActionSheetAppearance()
        
        //Colors
        appearance.backgroundColor = UIColor(red: 16/256, green: 32/256, blue: 50/256, alpha: 0.8)
        appearance.separatorColor = UIColor.red
        appearance.selectionColor = UIColor(red: 5/256, green: 10/256, blue: 15/256, alpha: 1)
        appearance.textColor = UIColor(red: 31/256, green: 154/256, blue: 254/256, alpha: 1)
        appearance.textColor = UIColor(red: 31/256, green: 154/256, blue: 254/256, alpha: 1)
        appearance.cencelButtonColor = UIColor.red

        appearance.headerColor = UIColor(red: 16/256, green: 32/256, blue: 50/256, alpha: 0.8)
        appearance.headerTitleColor = UIColor.lightGray
        appearance.headerMessageColor = UIColor.lightGray.withAlphaComponent(0.6)

        appearance.datePickerTextColor = UIColor.white
        
        //Fonts
        appearance.headerTitleFont = UIFont.systemFont(ofSize: 14)
        appearance.headerMessageFont = UIFont.systemFont(ofSize: 12)
        appearance.buttonTextFont = UIFont.systemFont(ofSize: 16)
        appearance.cancelButtonTextFont = UIFont.systemFont(ofSize: 18)
        appearance.pickerTextFont = UIFont.systemFont(ofSize: 22)

        return appearance
    }
    
    lazy var dateFormatter: DateFormatter = {
        let languageIdentifier = Locale.preferredLanguages.first!
        let locale = Locale(identifier: languageIdentifier)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy h:mm"
        
        dateFormatter.locale = locale
        return dateFormatter
    }()

    @IBAction func action(_ sender: Any) {
        let actionSheet = ActionSheet()
        actionSheet.appearance = appearance
        
        let header = ActionSheetHeaderView(title: "Twitter.com Twitter.com Twitter.co Twitter.com Twitter.com Twitter.com",
                                           message: "message message message message message message message message message message")
        
        let openButton = ActionSheetButton(icon: UIImage(named: "1")!,
                                           title: "Open in Open in Open in Open in Open in Open in") {
                                            
                                            actionSheet.hide()
                                            self.actionLabel.text = "Open in..."
        }
        
        let copyButton = ActionSheetButton(icon: UIImage(named: "2")!,
                                           title: "Copy Link") {
                                            
                                            actionSheet.hide()
                                            self.actionLabel.text = "Copy Link"
        }

        let readingButton = ActionSheetButton(title: "Add to Reading List") {
            actionSheet.hide()
            self.actionLabel.text = "Add to Reading List"
        }
        
        actionSheet.addCancelButonWith(title: "Cancel") {
            actionSheet.hide()
            
        }

        actionSheet.addItems([header, openButton, copyButton, readingButton])
        actionSheet.show(from: self)
    }
    
    @IBAction func dateAction(_ sender: Any) {
        let actionSheet = ActionSheet()
        actionSheet.appearance = appearance

        let datePicker = ActionSheetDatePickerView(dateFormat: .monthFirst, selectedDate: date) { (selectedDate) in
            self.date = selectedDate
        }
        
        let searchButton = ActionSheetButton(title: "Search") {
            actionSheet.hide()
            self.dateLabel.text = self.dateFormatter.string(from: self.date)
        }
        
        actionSheet.addCancelButonWith(title: "Cancel") {
            actionSheet.hide()

        }

        actionSheet.addItems([datePicker, searchButton])
        actionSheet.show(from: self)
    }
    
    @IBAction func timeAction(_ sender: Any) {
        let actionSheet = ActionSheet()
        actionSheet.appearance = appearance
        
        let timePicker = ActionSheetDatePickerView(timeFormat: .H24, selectedDate: date) { (selectedDate) in
            self.date = selectedDate
        }
        
        let searchButton = ActionSheetButton(title: "Search") {
            actionSheet.hide()
            self.dateLabel.text = self.dateFormatter.string(from: self.date)
        }
        
        actionSheet.addItems([timePicker, searchButton])
        actionSheet.show(from: self)
    }
}

