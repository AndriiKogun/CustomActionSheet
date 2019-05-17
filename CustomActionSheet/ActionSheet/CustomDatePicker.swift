//
//  CustomDatePicker.swift
//  CustomActionSheet
//
//  Created by Andrii on 5/17/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

protocol CustomDatePickerDelegate: class {
    func dateDidSelected(date: Date)
}

class CustomDatePicker: UIView {
    
    weak var delegate: CustomDatePickerDelegate?
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private let appearance: ActionSheetAppearance
    
    private var selectedMounthRow: Int = 0
    private var selectedDayRow: Int = 0
    private var selectedYearRow: Int = 0
    
    private var years = [Year]()
    private var months = [Month]()
    private var selectedDay = "1"
    private var selectedDate = Date()
    
    //MARK: - Init
    init(appearance: ActionSheetAppearance) {
        self.appearance = appearance
        super.init(frame: CGRect.zero)
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
        let calendar = Calendar.current
        var startDateComponents = calendar.dateComponents(in: TimeZone.current, from: selectedDate)
        let currentYear = startDateComponents.year!
        
        for number in 0...currentYear + 1000 {
            years.append(Year(number: number))
        }
        
        months = [Month]()
        
        for number in 1...12 {
            months.append(Month(number, selectedDate: selectedDate))
        }
        
        selectedMounthRow = startDateComponents.month! - 1
        selectedDayRow = startDateComponents.day! - 1
        let selectedYearRow = startDateComponents.year!
        
        selectedDay = months[selectedMounthRow].days[selectedDayRow]
        
        pickerView.selectRow(selectedMounthRow, inComponent: 0, animated: false)
        pickerView.selectRow(selectedDayRow, inComponent: 1, animated: false)
        pickerView.selectRow(selectedYearRow, inComponent: 2, animated: false)
        
        pickerView(pickerView, didSelectRow: selectedMounthRow, inComponent: 0)
        pickerView(pickerView, didSelectRow: selectedDayRow, inComponent: 1)
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension CustomDatePicker : UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return months.count
        } else if component == 1  {
            return months[selectedMounthRow].days.count
        } else {
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return months[row].name
        } else if component == 1 {
            return months[selectedMounthRow].days[row]
        } else {
            return years[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedMounthRow = row
            pickerView.reloadComponent(1)
            
            if months[row].days.firstIndex(of: selectedDay) == nil {
                let index = months[row].days.count - 1
                selectedDay = months[row].days[index]
                pickerView.selectRow(index, inComponent: 1, animated: false)
            }
        }
        
        if component == 1 {
            selectedDay = months[selectedMounthRow].days[row]
        }
        
        if component == 2 {
            selectedYearRow = row
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.dateFormat = "d LLLL yyyy"
        
        let selectedMonth = months[selectedMounthRow].name!
        let selectedYear = years[selectedYearRow].name
        
        let date = dateFormatter.date(from: selectedDay + " " + selectedMonth + " " + selectedYear) ?? Date()
        selectedDate = date
        delegate?.dateDidSelected(date: date)
        
        if component == 2 {
            setup()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var title: String!
        var myAttribute: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key.foregroundColor: appearance.datePickerTextColor]
        
        if component == 0 {
            title = months[row].name
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .left
            myAttribute[NSAttributedString.Key.paragraphStyle] = paragraph
            
        } else if component == 1 {
            title = months[selectedMounthRow].days[row]
        } else {
            title = years[row].name
        }
        
        return NSAttributedString(string: title, attributes: myAttribute)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 160
        } else if component == 1 {
            return 40
        } else if component == 2 {
            return 80
        }
        return 0
    }
}


private class Month {
    
    var name: String!
    var days = [String]()
    var number: Int!
    
    private var selectedDate: Date!
    
    init(_ number: Int, selectedDate: Date) {
        self.name = monthName(number)
        self.number = number
        self.selectedDate = selectedDate
        
        let endDay = numberOfDays(number)!
        
        for day in 1...endDay {
            days.append(String(day))
        }
    }
    
    private func numberOfDays(_ month: Int) -> Int? {
        let calendar = Calendar.current
        let nowDateComponents = calendar.dateComponents(in: TimeZone.current, from: selectedDate)
        let monthDateComponents = DateComponents(year: nowDateComponents.year, month: month)
        let date = calendar.date(from: monthDateComponents)
        let range = calendar.range(of: .day, in: .month, for: date!)
        return range?.count
    }
    
    private func monthName(_ month: Int) -> String {
        let calendar = Calendar.current
        let nowDateComponents = calendar.dateComponents(in: TimeZone.current, from: Date())
        let dateComponents = DateComponents(year: nowDateComponents.year, month: month)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let date = calendar.date(from: dateComponents)
        return dateFormatter.string(from: date!)
    }
}

private struct Year {
    var name: String
    var number: Int
    
    init(number: Int) {
        self.number = number
        self.name = String(number)
    }
}
