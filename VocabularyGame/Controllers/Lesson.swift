//
//  Lesson.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/29/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit

class Level {
    
    //MARK: Properties
    
    var isOpenned: Bool = false

    var listVocabulary: [LessonItem] = []
    var levelTime: Double = 0
    var levelNumberRamdom: Int = 0
    var levelID: String?
    var levelPriority: String?
    var levelName: String?
    var levelThumnail: String?
    
    var starCount = 0
    
    //MARK: Initialization
    
    init?(isOpenned: Bool, name: String?, id: String?, priority: String?, time: Double, randomNum: Int, thumnail: String?, listVocabulary: Array<LessonItem>) {
        self.isOpenned = isOpenned
        self.levelName = name
        self.levelID = id
        self.levelPriority = priority
        self.levelTime = time
        self.levelNumberRamdom = randomNum
        self.listVocabulary = listVocabulary
        self.levelThumnail = thumnail
    }
}
