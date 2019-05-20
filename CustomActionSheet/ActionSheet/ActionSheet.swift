//
//  ActionSheetController.swift
//  CustomActionSheet
//
//  Created by A K on 5/13/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

enum ActionSheetType {
    case date
    case time
}

class ActionSheet: UIViewController {
    
    var appearance: ActionSheetAppearance

    func show(from viewController: UIViewController) {
        modalPresentationStyle = .overFullScreen
        viewController.present(self, animated: false, completion: nil)
    }
    
    func addItems(_ items: [ActionSheetItem]) {
        for (index, item) in items.enumerated() {
            item.appearance = appearance
            item.delegate = self
            stackView.addArrangedSubview(item)
            
            if item is ActionSheetButton, index == items.count - 1 {
                let button = items.last as! ActionSheetButton
                button.hideSeparator()
            }
        }
    }
    
    func addCancelButonWith(title: String, tappedBlock: @escaping () -> Void) {
        cancelButton = ActionSheetButton(title: title) {
            self.hide()
            tappedBlock()
        }
        
        var newAppearance = appearance
        newAppearance.textColor = appearance.cencelButtonColor
        newAppearance.buttonTextFont = appearance.cancelButtonTextFont
        
        cancelButton?.appearance = newAppearance
        cancelButton?.hideSeparator()
        cancelButton?.clipsToBounds = true
        cancelButton?.layer.cornerRadius = 16.0
    }
    
    func hide() {
        hideAction()
    }

    //MARK: - Private
    private var bottomAnchor: NSLayoutConstraint!

    private var containerView: UIView = {
        let containerView = UIView()
        containerView.contentMode = .scaleAspectFill
        containerView.layer.cornerRadius = 16.0
        containerView.clipsToBounds = true
        return containerView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor.clear
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()

    private var contentView: UIView = {
        let contentView = UIView()
        
        return contentView
    }()
    
    private var hasHomeIndicator: Bool {
        guard #available(iOS 11.0, *), let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom, bottomPadding > 0 else {
            return false
        }
        return true
    }
    
    private var cancelButton: ActionSheetButton?
    
    init() {
        self.appearance = ActionSheetAppearance()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAction()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideAction))
        tap.delegate = self
        contentView.addGestureRecognizer(tap)
    }
    
    private func showAction() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.bottomAnchor.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func hideAction() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor.clear
            self.bottomAnchor.constant = self.view.bounds.height
            self.view.layoutIfNeeded()

        }, completion: { (completion) in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    private func setupLayout() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        bottomAnchor = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchor.isActive = true
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true

        if let cancelButton = cancelButton {
            contentView.addSubview(cancelButton)
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 7).isActive = true
            cancelButton.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            cancelButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            
            if hasHomeIndicator {
                cancelButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
            } else {
                cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
            }
        } else {
            if hasHomeIndicator {
                containerView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
            } else {
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
            }
        }
    }
}


extension ActionSheet: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

