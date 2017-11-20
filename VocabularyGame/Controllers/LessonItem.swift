//
//  LessonItem.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/17/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LessonItem {
    
    //MARK: Properties
    let ref: DatabaseReference?
    
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
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.levelName = snapshotValue["levelName"] as! String
        self.id = snapshotValue["id"] as? String
        self.name = snapshotValue["name"] as! String
        self.image = snapshotValue["image"] as? String
        self.audio = snapshotValue["audio"] as? String
        self.defination = snapshotValue["defination"] as? String
        self.example = snapshotValue["example"] as? String
        self.spelling = snapshotValue["spelling"] as? String
        ref = snapshot.ref
    }
}
