//
//  ActionSheetHeaderView.swift
//  CustomActionSheet
//
//  Created by A K on 5/16/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class ActionSheetHeaderView: UIView {

    private let title: String
    private let appearance: ActionSheetAppearance
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = appearance.headerColor
        return contentView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = appearance.headerTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private lazy var separatorView: UIView = {
        var separatorView = UIView()
        separatorView.backgroundColor = appearance.separatorColor
        return separatorView
    }()

    init(title: String, appearance: ActionSheetAppearance) {
        self.title = title
        self.appearance = appearance
        super.init(frame: CGRect.zero)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
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

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:-16).isActive = true
    }
}
