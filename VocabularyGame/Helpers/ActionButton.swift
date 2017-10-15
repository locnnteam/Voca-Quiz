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
    
    @IBInspectable var imageForHighlighted: UIImage?
    
    override var backgroundColor: UIColor? {
        didSet {
            if originalBackgroundColor == nil {
                originalBackgroundColor = backgroundColor
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let imageNormal = self.image(for: .normal)
        self.setImage(imageNormal, for: .normal)
        if imageForHighlighted != nil {
        self.setImage(imageForHighlighted, for: .highlighted)
        } else {
            self.alpha = 0.5
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 1.0
        let imageNormal = self.image(for: .normal)
        self.setImage(imageNormal, for: .highlighted)
        self.setImage(imageNormal, for: .normal)
        
        super.touchesBegan(touches, with: event)
        self.sendActions(for: UIControlEvents.touchUpInside)
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
