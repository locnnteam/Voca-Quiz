//
//  LessonModel.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 9/4/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class LessonModel: NSObject {

    static func loadLessonData(lessonURL: String, completion:@escaping (_ levelItems: [Level]) -> Void){
        var levelItems: [Level] = []
        
        Alamofire.request(lessonURL).responseJSON { response in
            if (response.error == nil) {
                
                if let data = response.data{
                    let json = JSON(data: data)
                    //init lesson
                    for index in 0...(json.count - 1){
                        guard let lessons = json[index]["lessons"].array else{
                            debugPrint("Lesson is null")
                            break
                        }

                        var lessonList: [LessonItem?] = []
                        
                        for iLesson in 0...(lessons.count - 1){
                            let id = lessons[iLesson]["id"].string
                            let name = lessons[iLesson]["name"].string!
                            let image = lessons[iLesson]["imageURL"].string
                            let audio = lessons[iLesson]["audioURL"].string
                            let defination = lessons[iLesson]["defination"].string
                            let example = lessons[iLesson]["example"].string
                            let spelling = lessons[iLesson]["spelling"].string
                            let lessonItem = LessonItem(id: id, name: name, image: image, audio: audio, defination: defination, example: example, spelling: spelling)
                            lessonList.append(lessonItem)
                        }
                        
                        guard let randomNumber = json[index]["levelNumberRandom"].int else{
                            debugPrint("levelNumberRandom is nil")
                            continue
                        }
                        
                        guard let id = json[index]["levelID"].string else{
                            debugPrint("levelID is nil")
                            continue
                        }
                        
                        guard let priority = json[index]["levelPriority"].string else{
                            debugPrint("levelPriority is nil")
                            continue
                        }
                        
                        guard let name = json[index]["levelName"].string else{
                            debugPrint("levelName is nil")
                            continue
                        }
                        
                        guard let thumnail = json[index]["levelThumnailURL"].string else{
                            debugPrint("levelThumnailURL is nil")
                            continue
                        }
                        
                        guard let time = json[index]["levelTime"].double else{
                            debugPrint("levelTime is nil")
                            continue
                        }
                        
                        let level = Level(isOpenned: false, name: name, id: id, priority: priority, time: time, randomNum: randomNumber, thumnail: thumnail, listVocabulary: lessonList as! Array<LessonItem>)
                        
                        levelItems.append(level!)
                    }
                    
                    
                }
            }
            completion(levelItems)
        }
    }
}
