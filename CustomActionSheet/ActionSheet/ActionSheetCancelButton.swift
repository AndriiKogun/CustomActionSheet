//
//  ActionSheetCancelButton.swift
//  CustomActionSheet
//
//  Created by A K on 5/16/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class ActionSheetCancelButton: ActionSheetItem {

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
    
    init(title: String, tappedBlock: @escaping () -> Void) {
        self.title = title
        super.init(frame: CGRect.zero)
        self.dissmissBlock = tappedBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var appearance: ActionSheetAppearance! {
        didSet {
            setupLayout()
        }
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
        if let dissmissBlock = dissmissBlock {
            dissmissBlock()
        }
    }
}
