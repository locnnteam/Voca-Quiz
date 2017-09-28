//
//  Utils.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 9/6/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static func perfomDelay(time: Double, closure:@escaping ()->()) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                closure()
            }
    }
}
