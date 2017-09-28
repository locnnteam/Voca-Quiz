//
//  UIImageViewExt.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 8/27/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
