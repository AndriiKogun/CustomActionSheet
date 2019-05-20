//
//  ActionSheetItem.swift
//  CustomActionSheet
//
//  Created by A K on 5/19/19.
//  Copyright © 2019 A K. All rights reserved.
//

import UIKit

class ActionSheetItem: UIView {

    weak var delegate: ActionSheet?
    var dissmissBlock: (() -> Void)?
    var appearance: ActionSheetAppearance!
}
