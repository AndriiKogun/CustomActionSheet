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
    
    private var isEnglish: Bool {
        guard let code = Locale.preferredLanguages.first?.components(separatedBy: "-").first else { return false }
        
        if code == "en" {
            return true
        } else {
            return false
        }
    }
    
    private let appearance: ActionSheetAppearance

    private var selectedMounthRow: Int = 0
    private var selectedDayRow: Int = 0
    private var selectedYearRow: Int = 0
    
    private var years = [Year]()
    private var months = [Month]()
    
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
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let currentYear = dateComponents.year!
        
        for number in 1...currentYear + 1000 {
            years.append(Year(number: number))
        }
        
        for number in 1...12 {
            months.append(Month(number, selectedDate: selectedDate))
        }
        
        selectedMounthRow = dateComponents.month! - 1
        selectedDayRow = dateComponents.day! - 1
        selectedYearRow = dateComponents.year! - 1
        
        if isEnglish {
            pickerView.selectRow(selectedMounthRow, inComponent: 0, animated: false)
            pickerView.selectRow(selectedDayRow, inComponent: 1, animated: false)
        } else {
            pickerView.selectRow(selectedDayRow, inComponent: 0, animated: false)
            pickerView.selectRow(selectedMounthRow, inComponent: 1, animated: false)
        }
        
        pickerView.selectRow(selectedYearRow, inComponent: 2, animated: false)
    }
    
    func didSelectDate() {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        dateComponents.year = selectedYearRow + 1
        dateComponents.month = selectedMounthRow + 1
        dateComponents.day = selectedDayRow + 1
        let date = calendar.date(from: dateComponents)!
        selectedDate = date
        delegate?.dateDidSelected(date: date)
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension CustomDatePicker : UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            if isEnglish {
                return months.count
            } else {
                return months[selectedMounthRow].days.count
            }
        } else if component == 1  {
            if isEnglish {
                return months[selectedMounthRow].days.count
            } else {
                return months.count
            }
        } else {
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if isEnglish {
                return months[row].name
            } else {
                return months[selectedMounthRow].days[row].name
            }
        } else if component == 1 {
            if isEnglish {
                return months[selectedMounthRow].days[row].name
            } else {
                return months[row].name
            }
        } else {
            return years[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if isEnglish {
                selectedMounthRow = row
                pickerView.reloadComponent(1)
                if months[row].days.first(where: {( $0.number == selectedDayRow )}) == nil {
                    let index = months[row].days.count - 1
                    pickerView.selectRow(index, inComponent: 1, animated: false)
                }
            } else {
                selectedDayRow = row
            }
        }
        if component == 1 {
            if isEnglish {
                selectedDayRow = row
            } else {
                selectedMounthRow = row
                pickerView.reloadComponent(1)
                if months[row].days.first(where: {( $0.number == selectedDayRow )}) == nil {
                    let index = months[row].days.count - 1
                    pickerView.selectRow(index, inComponent: 1, animated: false)
                }
            }
        }
        if component == 2 {
            selectedYearRow = row
        }
        didSelectDate()
        if component == 2 {
            months.removeAll()
            for number in 1...12 {
                months.append(Month(number, selectedDate: selectedDate))
            }
            pickerView.reloadComponent(1)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title: String!
        var myAttribute: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key.foregroundColor: appearance.datePickerTextColor]

        if component == 0 {
            if isEnglish {
                title = months[row].name
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .left
                myAttribute[NSAttributedString.Key.paragraphStyle] = paragraph
            } else {
                title = months[selectedMounthRow].days[row].name
            }
        } else if component == 1 {
            if isEnglish {
                title = months[selectedMounthRow].days[row].name
            } else {
                title = months[row].name
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .left
                myAttribute[NSAttributedString.Key.paragraphStyle] = paragraph
            }
        } else {
            title = years[row].name
        }
        return NSAttributedString(string: title, attributes: myAttribute)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            if isEnglish {
                return 120
            } else {
                return 40
            }
        } else if component == 1 {
            if isEnglish {
                return 40
            } else {
                return 120
            }
        } else if component == 2 {
            return 100
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36
    }
}


private class Month {
    
    var name: String!
    var days = [Day]()
    var number: Int!
    
    private var selectedDate: Date!
    
    init(_ number: Int, selectedDate: Date) {
        self.name = monthName(for: number)
        self.number = number
        self.selectedDate = selectedDate
        
        let endDay = numberOfDays(at: number)!
        
        for day in 1...endDay {
            days.append(Day(number: day))
        }
    }
    
    private func numberOfDays(at number: Int) -> Int? {
        let calendar = Calendar.current
        let nowDateComponents = calendar.dateComponents(in: TimeZone.current, from: selectedDate)
        let monthDateComponents = DateComponents(year: nowDateComponents.year, month: number)
        let date = calendar.date(from: monthDateComponents)
        let range = calendar.range(of: .day, in: .month, for: date!)
        return range?.count
    }
    
    private func monthName(for number: Int) -> String {
        let languageIdentifier = Locale.preferredLanguages.first!
        let locale = Locale(identifier: languageIdentifier)
        let calendar = Calendar.current
        let nowDateComponents = calendar.dateComponents(in: TimeZone.current, from: Date())
        let dateComponents = DateComponents(year: nowDateComponents.year, month: number)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "MMMM"
        let date = calendar.date(from: dateComponents)
        return dateFormatter.string(from: date!)
    }
}

private struct Day {
    var name: String
    var number: Int
    
    init(number: Int) {
        self.number = number
        self.name = String(number)
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
