//
//  UIBezierPathExt.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/21/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        debugPrint("[DEBUG]\(rect)")
            self.init()
            
            //Calculate Radius of Arcs using Pythagoras
            let sideOne = rect.width * 0.4
            let sideTwo = rect.height * 0.3
            let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2
            
            //Left Hand Curve
            self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)
            
            //Top Centre Dip
            self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))
            
            //Right Hand Curve
            self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
            
            //Right Bottom Line
            self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))
            
            //Left Bottom Line
            self.close()
        }
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
