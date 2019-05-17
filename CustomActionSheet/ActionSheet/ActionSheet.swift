//
//  ActionSheetController.swift
//  CustomActionSheet
//
//  Created by A K on 5/13/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class ActionSheet: UIViewController {
    
    var appearance: ActionSheetAppearance
    
    var date = Date()

    func show(from viewController: UIViewController) {
        modalPresentationStyle = .overFullScreen
        viewController.present(self, animated: false, completion: nil)
    }
    
    func addHeaderWith(title: String, message: String) {
        let header = ActionSheetHeaderView(title: title, message: message, appearance: appearance)
        stackView.addArrangedSubview(header)
    }
    
    func addDatePicker(didChangeBlock completionBlock: ((_ date: Date) -> Void)?) {
        let datePicker = ActionSheetDatePickerView(appearance: appearance) { (date) in
            self.date = date
            if let completionBlock = completionBlock {
                completionBlock(date)
            }
        }
        stackView.addArrangedSubview(datePicker)
    }
    
    func addButonWith(title: String, tappedBlock: @escaping () -> Void) {
        let button = ActionSheetButton(title: title, appearance: appearance, tappedBlock: {
            self.hide()
            tappedBlock()
        })
        stackView.addArrangedSubview(button)
    }
    
    func addButonWith(icon: UIImage, title: String, tappedBlock: @escaping () -> Void) {
        let button = ActionSheetButton(icon: icon, title: title, appearance: appearance, tappedBlock: {
            self.hide()
            tappedBlock()
        })
        stackView.addArrangedSubview(button)
    }
    
    var willDismissBlock: (() -> Void)?
    var didDismissBlock: (() -> Void)?

    //MARK: - Private
    private var bottomAnchor: NSLayoutConstraint!

    private var containerView: UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 16.0
        containerView.clipsToBounds = true
        return containerView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.contentMode = .scaleAspectFit
        stackView.backgroundColor = UIColor.clear
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 16.0
        return stackView
    }()
    
    private lazy var cancelButtonView: ActionSheetCancelButton = {
        let cancelButtonView = ActionSheetCancelButton(title: "Cancel", appearance: appearance, tappedBlock: {
            self.hide()
        })
        cancelButtonView.clipsToBounds = true
        cancelButtonView.layer.cornerRadius = 16.0
        return cancelButtonView
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
    
    init() {
        self.appearance = ActionSheetAppearance()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayour()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        show()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        tap.delegate = self
        contentView.addGestureRecognizer(tap)
    }
    
    private func show() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.bottomAnchor.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func hide() {
        if let willDismissBlock = self.willDismissBlock {
            willDismissBlock()
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor.clear
            self.bottomAnchor.constant = 300
            self.view.layoutIfNeeded()

        }, completion: { (completion) in
            if let didDismissBlock = self.didDismissBlock {
                didDismissBlock()
            }

            self.dismiss(animated: false, completion: nil)
        })
    }
    
    private func setupLayour() {
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

        contentView.addSubview(cancelButtonView)
        cancelButtonView.translatesAutoresizingMaskIntoConstraints = false
        cancelButtonView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 6).isActive = true
        cancelButtonView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cancelButtonView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        if hasHomeIndicator {
            cancelButtonView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            cancelButtonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        }
    }
}


extension ActionSheet: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

