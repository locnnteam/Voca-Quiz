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
    var fadeDuration: Double = 0.08
    
    override var image: UIImage? {
//        didSet{
//            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
//                self.transform = CGAffineTransform.identity
//            }) { (animationCompleted: Bool) -> Void in}
//        }
    
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
    var fadeDuration: Double = 0.08
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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
//        didSet{
//            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
//                self.transform = CGAffineTransform.identity
//            }) { (animationCompleted: Bool) -> Void in            }
//        }
    }
}
