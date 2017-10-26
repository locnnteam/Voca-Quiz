//
//  FadeImageView.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/19/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit

class FadeImageView: UIImageView
{
    @IBInspectable
    var fadeDuration: Double = 0.1
    
    override var image: UIImage? {
        get {
            return super.image
        }
        
        set(newImage) {
            if let img = newImage {
                CATransaction.begin()
                CATransaction.setAnimationDuration(self.fadeDuration)
                
                let transition = CATransition()
                transition.type = kCATransitionPush
                
                super.layer.add(transition, forKey: kCATransition)
                super.image = img
                
                CATransaction.commit()
            } else {
                super.image = nil
            }
        }
    }
}

class FadeLabel: UILabel
{
    @IBInspectable
    var fadeDuration: Double = 0.1
    override var text: String?{
        get {
            return super.text
        }
        set(newText) {
            if let text = newText {
                CATransaction.begin()
                CATransaction.setAnimationDuration(self.fadeDuration)
                
                let transition = CATransition()
                transition.type = kCATransitionPush
                
                super.layer.add(transition, forKey: kCATransition)
                super.text = text
                
                CATransaction.commit()
                
            } else {
                super.text = nil
            }
        }
    }
}
