//
//  Lesson.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/29/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Level {
    
    //MARK: Properties
    let ref:  DatabaseReference?
    
    var isOpenned: Bool = false

    var listVocabulary: [LessonItem] = []
    var levelTime: Double = 0
    var levelNumberRandom: Int = 0
    var levelID: String?
    var levelPriority: String?
    var levelName: String?
    var levelThumnail: String?

    //MARK: Initialization
    
    init?(isOpenned: Bool, name: String?, id: String?, priority: String?, time: Double, randomNum: Int, thumnail: String?, listVocabulary: [LessonItem]) {
        self.isOpenned = isOpenned
        self.levelName = name
        self.levelID = id
        self.levelPriority = priority
        self.levelTime = time
        self.levelNumberRandom = randomNum
        self.listVocabulary = listVocabulary
        self.levelThumnail = thumnail!
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]

        self.levelName = snapshotValue["levelName"] as? String
        self.levelID = snapshotValue["levelPriority"] as? String
        self.levelPriority = snapshotValue["levelPriority"] as? String
        self.levelTime = snapshotValue["levelTime"] as! Double
        self.levelNumberRandom = snapshotValue["levelNumberRandom"] as! Int
        self.levelThumnail = snapshotValue["levelThumnailURL"] as? String
        
        //LessonItem Data
//        let lessonItem = LessonItem(snapshot: snapshot.)
        self.listVocabulary = snapshotValue["lessons"] as! [LessonItem]
        ref = snapshot.ref
    }
}
