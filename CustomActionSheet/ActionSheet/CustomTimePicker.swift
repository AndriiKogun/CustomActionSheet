//
//  CustomTimePicker.swift
//  CustomActionSheet
//
//  Created by A K on 5/19/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

protocol CustomTimePickerDelegate: class {
    func dateDidSelected(date: Date)
}

class CustomTimePicker: UIView {

    weak var delegate: CustomTimePickerDelegate?
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private var isEnglish: Bool {
        guard let code = Locale.preferredLanguages.first?.components(separatedBy: "-").first else { return false }
        
        if code == "en" {
            return true
        } else {
            return false
        }
    }
    
    private let appearance: ActionSheetAppearance

    private var selectedHourRow: Int = 0
    private var selectedMinuteRow: Int = 0
    private var selectedTimeFormatRow: Int = 0

    private var hours = [Hour]()
    private var minutes = [Minute]()
    private var times = [Time]()

    private var selectedDate: Date!

    //MARK: - Init
    init(selectedDate: Date, appearance: ActionSheetAppearance) {
        self.appearance = appearance
        super.init(frame: CGRect.zero)
        self.selectedDate = selectedDate
        setupLayout()
        setupUI()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pickerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    private func setupUI() {
        backgroundColor = appearance.backgroundColor
    }
    
    private func setup() {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        
        if isEnglish {
            for number in 1...12 {
                hours.append(Hour(number: number))
            }
            
            times.append(Time(number: 0))
            times.append(Time(number: 1))
        } else {
            for number in 0...23 {
                hours.append(Hour(number: number))
            }
        }
        
        for number in 0...59 {
            minutes.append(Minute(number: number))
        }
        
        if isEnglish {
            if dateComponents.hour == 0, 0...59 ~= dateComponents.minute! {
                selectedHourRow = dateComponents.hour! + 11
                selectedTimeFormatRow = 0
            } else if 1...11 ~= dateComponents.hour! {
                selectedHourRow = dateComponents.hour! - 1
                selectedTimeFormatRow = 0
            } else {
                selectedHourRow = dateComponents.hour! - 13
                selectedTimeFormatRow = 1
            }
        } else {
            selectedHourRow = dateComponents.hour!
        }

        selectedMinuteRow = dateComponents.minute!
        
        if isEnglish {
            pickerView.selectRow(selectedTimeFormatRow, inComponent: 2, animated: false)
        }
        
        pickerView.selectRow(selectedHourRow, inComponent: 0, animated: false)
        pickerView.selectRow(selectedMinuteRow, inComponent: 1, animated: false)
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension CustomTimePicker : UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if isEnglish {
            return 3
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        } else if component == 1 {
            return minutes.count
        } else if component == 2 {
            return times.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return hours[row].name
        } else if component == 1 {
            return minutes[row].name
        } else if component == 2 {
            return times[row].name
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedHourRow = row
        }
        if component == 1 {
            selectedMinuteRow = row
        }
        
        if component == 2 {
            selectedTimeFormatRow = row
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        dateComponents.minute = selectedMinuteRow
        
        if isEnglish {
            if selectedTimeFormatRow == 0, selectedHourRow + 1 == 12, 0...59 ~= selectedMinuteRow {
                dateComponents.hour = selectedHourRow - 11
            } else if selectedTimeFormatRow == 1, 1...11 ~= selectedHourRow + 1 {
                dateComponents.hour = selectedHourRow + 13
            } else {
               dateComponents.hour = selectedHourRow + 1
            }
            
        } else {
            dateComponents.hour = selectedHourRow
        }
        
        let date = calendar.date(from: dateComponents)!
        selectedDate = date
        delegate?.dateDidSelected(date: date)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        var title: String!
        let myAttribute = [NSAttributedString.Key.foregroundColor: appearance.datePickerTextColor, NSAttributedString.Key.paragraphStyle: paragraph]
        
        if component == 0 {
            title = hours[row].name
        } else if component == 1 {
            title = minutes[row].name
        } else if component == 2 {
            title = times[row].name
        } else {
            return nil
        }
        return NSAttributedString(string: title, attributes: myAttribute)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36
    }
}

private struct Hour {
    var name: String
    var number: Int
    
    init(number: Int) {
        self.number = number
        self.name = String(number)
    }
}

private struct Minute {
    var name: String
    var number: Int
    
    init(number: Int) {
        self.number = number
        
        if number < 10 {
            self.name = "0" + String(number)
        } else {
            self.name = String(number)
        }
    }
}

private struct Time {
    var name: String
    var number: Int

    init(number: Int) {
        self.number = number
        
        if number == 0 {
            self.name = "AM"
        } else {
            self.name = "PM"
        }
    }
}