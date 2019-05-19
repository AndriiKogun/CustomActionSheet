//
//  ActionSheetDatePickerView.swift
//  CustomActionSheet
//
//  Created by A K on 5/17/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class ActionSheetDatePickerView: ActionSheetItem {

    private let completionBlock: (_ date: Date) -> Void
    private let type: ActionSheetType
    private let selectedDate: Date
    
    private var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var separatorView: UIView = {
        var separatorView = UIView()
        separatorView.backgroundColor = appearance.separatorColor
        return separatorView
    }()
    
    private lazy var datePicker: CustomDatePicker = {
        let datePicker = CustomDatePicker(selectedDate: selectedDate, appearance: appearance)
        datePicker.delegate = self
        return datePicker
    }()
    
    private lazy var timePicker: CustomTimePicker = {
        let timePicker = CustomTimePicker(selectedDate: selectedDate, appearance: appearance)
        timePicker.delegate = self
        return timePicker
    }()
    
    init(type: ActionSheetType, selectedDate: Date, completionBlock: @escaping (_ date: Date) -> Void) {
        self.type = type
        self.selectedDate = selectedDate
        self.completionBlock = completionBlock
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var appearance: ActionSheetAppearance! {
        didSet {
            setupLayout()
            contentView.backgroundColor = appearance.backgroundColor
        }
    }
    
    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.topAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        if type == .date {
            contentView.addSubview(datePicker)
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            datePicker.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            datePicker.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        } else if type == .time {
            contentView.addSubview(timePicker)
            timePicker.translatesAutoresizingMaskIntoConstraints = false
            timePicker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            timePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            timePicker.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            timePicker.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        }
    }
}

//MARK: - CustomDatePickerDelegate
extension ActionSheetDatePickerView: CustomDatePickerDelegate, CustomTimePickerDelegate {
    func dateDidSelected(date: Date) {
        completionBlock(date)
    }
}


