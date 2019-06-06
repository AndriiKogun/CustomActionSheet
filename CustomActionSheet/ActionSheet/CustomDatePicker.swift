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
    
    enum Format: Int {
        case yearFirst
        case monthFirst
        case dayFirst
        
        var yearIndex: Int {
            switch self {
            case .dayFirst: return 2
            case .monthFirst: return 2
            case .yearFirst: return 0
            }
        }
        
        var monthIndex: Int {
            switch self {
            case .dayFirst: return 1
            case .monthFirst: return 0
            case .yearFirst: return 1
            }
        }

        var dayIndex: Int {
            switch self {
            case .dayFirst: return 0
            case .monthFirst: return 1
            case .yearFirst: return 2
            }
        }
    }
    
    weak var delegate: CustomDatePickerDelegate?
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private let appearance: ActionSheetAppearance
    private let dateFormat: Format

    private var selectedMounthRow: Int = 0
    private var selectedDayRow: Int = 0
    private var selectedYearRow: Int = 0
    
    private var years = [Year]()
    private var months = [Month]()
    
    private var selectedDate: Date!
    
    //MARK: - Init
    init(dateFormat: Format, selectedDate: Date, appearance: ActionSheetAppearance) {
        self.dateFormat = dateFormat
        self.appearance = appearance
        super.init(frame: CGRect.zero)
        self.selectedDate = selectedDate
        setupLayout()
        setupData()
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
    
    private func setupData() {
        for number in 1...3000 {
            years.append(Year(number: number))
        }
        
        for number in 1...12 {
            months.append(Month(number, selectedDate: selectedDate))
        }
        setDate(selectedDate, animated: false)
    }
    
    private func setDate(_ date: Date, animated: Bool) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        selectedMounthRow = dateComponents.month! - 1
        selectedDayRow = dateComponents.day! - 1
        selectedYearRow = dateComponents.year! - 1
        
        pickerView.selectRow(selectedDayRow, inComponent: dateFormat.dayIndex, animated: animated)
        pickerView.selectRow(selectedMounthRow, inComponent: dateFormat.monthIndex, animated: animated)
        pickerView.selectRow(selectedYearRow, inComponent: dateFormat.yearIndex, animated: animated)
    }
    
    func didSelectDate() {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        let year = selectedYearRow + 1

        dateComponents.year = year
        dateComponents.month = selectedMounthRow + 1
        if !((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0)) && selectedDayRow == 28 && selectedMounthRow == 1 {
            dateComponents.day = selectedDayRow
        } else {
            dateComponents.day = selectedDayRow + 1
        }
        
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
        if dateFormat.dayIndex == component {
            return months[selectedMounthRow].days.count
            
        } else if dateFormat.monthIndex == component {
            return months.count
            
        } else if dateFormat.yearIndex == component {
            return years.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if dateFormat.dayIndex == component {
            return months[selectedMounthRow].days[row].name
            
        } else if dateFormat.monthIndex == component {
            return months[row].name
            
        } else if dateFormat.yearIndex == component {
            return years[row].name
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if dateFormat.dayIndex == component {
            selectedDayRow = row
        }
        
        if dateFormat.monthIndex == component {
            selectedMounthRow = row
            pickerView.reloadComponent(dateFormat.dayIndex)
            if months[row].days.first(where: {( $0.number == selectedDayRow + 1 )}) == nil {
                let index = months[row].days.count - 1
                selectedDayRow = index
                pickerView.selectRow(index, inComponent: dateFormat.dayIndex, animated: false)
            }
        }
        
        if dateFormat.yearIndex == component {
            selectedYearRow = row
        }

        didSelectDate()
        
        if dateFormat.yearIndex == component {
            months.removeAll()
            for number in 1...12 {
                months.append(Month(number, selectedDate: selectedDate))
            }
            pickerView.reloadComponent(dateFormat.dayIndex)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        
        pickerView.subviews[1].backgroundColor = appearance.separatorColor
        pickerView.subviews[2].backgroundColor = appearance.separatorColor

        var title: String!
        let paragraph = NSMutableParagraphStyle()
        var myAttribute = [NSAttributedString.Key.foregroundColor: appearance.datePickerTextColor,
                           NSAttributedString.Key.font: appearance.pickerTextFont]
        
        if component == 0 {
            paragraph.alignment = .left
            myAttribute[NSAttributedString.Key.paragraphStyle] = paragraph
        }
        
        if component == 1 {
            paragraph.alignment = .center
            myAttribute[NSAttributedString.Key.paragraphStyle] = paragraph
        }
        
        if component == 2 {
            paragraph.alignment = .right
            myAttribute[NSAttributedString.Key.paragraphStyle] = paragraph
        }
        
        if dateFormat.dayIndex == component {
            title = months[selectedMounthRow].days[row].name
            
        } else if dateFormat.monthIndex == component {
            title = months[row].name
            paragraph.alignment = .left
            myAttribute[NSAttributedString.Key.paragraphStyle] = paragraph
            
        } else if dateFormat.yearIndex == component {
            title = years[row].name
        }
        
        label.attributedText = NSAttributedString(string: title, attributes: myAttribute)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if dateFormat.dayIndex == component {
            return 50
            
        } else if dateFormat.monthIndex == component {
            return 110

        } else if dateFormat.yearIndex == component {
            return 80

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
