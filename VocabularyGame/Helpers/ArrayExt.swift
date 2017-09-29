//
//  ArrayExt.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/4/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObject<T where T : Equatable>(obj: T) {
        self = self.filter({$0 as? T != obj})
    }
    
}
