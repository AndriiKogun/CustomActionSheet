//
//  ActionSheetDatePickerView.swift
//  CustomActionSheet
//
//  Created by A K on 5/17/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class ActionSheetDatePickerView: UIView {

    private let completionBlock: (_ date: Date) -> Void
    private let appearance: ActionSheetAppearance
    
    private var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var separatorView: UIView = {
        var separatorView = UIView()
        separatorView.backgroundColor = appearance.separatorColor
        return separatorView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = appearance.backgroundColor
        datePicker.setValue(appearance.datePickerTextColor, forKey: "textColor")
        datePicker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
        return datePicker
    }()
    
    init(appearance: ActionSheetAppearance, completionBlock: @escaping (_ date: Date) -> Void) {
        self.appearance = appearance
        self.completionBlock = completionBlock
        super.init(frame: CGRect.zero)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        contentView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    @objc private func datePickerAction(_ sender: UIDatePicker) {
        completionBlock(sender.date)
    }
}
