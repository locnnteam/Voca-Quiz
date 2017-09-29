//
//  LessonItem.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/17/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit

class LessonItem {
    
    //MARK: Properties
    
    var levelName: String
    var id: String?
    var name: String
    var image: String?
    var audio: String?
    var defination: String?
    var example: String?
    var spelling: String?
    
    var isSelected: Bool?
    
    //MARK: Initialization
    
    init?(levelName: String, id: String?, name: String?, image: String?, audio: String?, defination: String?,example: String?, spelling: String?) {
        
        guard let name = name else {
            return nil
        }
        guard let image = image else {
            return nil
        }
        guard let audio = audio else {
            return nil
        }
        
        // Initialize stored properties.
        self.levelName = levelName
        self.id = id
        self.name = name
        self.image = image
        self.audio = audio
        self.defination = defination
        self.example = example
        self.spelling = spelling
    }
}
