//
//  ActionSheetCancelButton.swift
//  CustomActionSheet
//
//  Created by A K on 5/16/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class ActionSheetCancelButton: UIView {

    private let tappedBlock: () -> Void
    private let appearance: ActionSheetAppearance
    private let title: String
    
    private lazy var sheetButton: UIButton = {
        let sheetButton = UIButton()
        sheetButton.backgroundColor = appearance.backgroundColor
        sheetButton.setTitle(title, for: .normal)
        sheetButton.setTitleColor(appearance.textColor, for: .normal)
        sheetButton.addTarget(self, action: #selector(touchDownAction(_:)), for: .touchDown)
        sheetButton.addTarget(self, action: #selector(touchDragOutsideAction(_:)), for: .touchDragOutside)
        sheetButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return sheetButton
    }()
    
    init(title: String, appearance: ActionSheetAppearance, tappedBlock: @escaping () -> Void) {
        self.title = title
        self.appearance = appearance
        self.tappedBlock = tappedBlock
        super.init(frame: CGRect.zero)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: 60).isActive = true

        addSubview(sheetButton)
        sheetButton.translatesAutoresizingMaskIntoConstraints = false
        sheetButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sheetButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sheetButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sheetButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    @objc private func touchDownAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.backgroundColor = self.appearance.selectionColor
        }
    }
    
    @objc private func touchDragOutsideAction(_ sender: UIButton) {
        sender.backgroundColor = self.appearance.backgroundColor
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        tappedBlock()
    }
}
