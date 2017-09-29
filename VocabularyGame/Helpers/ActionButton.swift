//
//  ActionButton.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/10/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit

class ActionButton: UIButton {
    
    var originalBackgroundColor: UIColor!
    
    override var backgroundColor: UIColor? {
        didSet {
            if originalBackgroundColor == nil {
                originalBackgroundColor = backgroundColor
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard let originalBackgroundColor = originalBackgroundColor else {
                return
            }
            
            backgroundColor = isHighlighted ? originalBackgroundColor : originalBackgroundColor
        }
    }
}
