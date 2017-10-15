//
//  SettingsItem.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/25/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit

class SettingsItem {
    //MARK: Properties
    
    var label: String
    var photo: UIImage?
    
    //MARK: Initialization
    
    init?(label: String, photo: UIImage?) {
        
        // The name must not be empty
        guard !label.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.label = label
        self.photo = photo
        
    }
}
