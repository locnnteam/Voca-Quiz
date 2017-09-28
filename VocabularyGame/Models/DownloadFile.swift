//
//  DownloadFile.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 7/23/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation

@objc protocol DownloadFileDelegate{
    func finishedDownload()
}

class DownloadFile: ImageDownLoadDelegate {
    
    //Download data
    private var audioDownloaded = false
    private var imageDownloaded = false
    private var name: String?
    private var listVocabulary = [LessonItem]()
    var delegate: DownloadFileDelegate?
    
    init(name: String?, listVocabulary: Array<LessonItem>) {
        self.name = name
        self.listVocabulary = listVocabulary
    }
    
    func isDataExist(levelName: String?, fileName: String?) -> Bool{
        let fileManager = FileManager.default
        let levelPath = DocumentsURL.appendingPathComponent("\(levelName!)")
        let fullPath = levelPath.appendingPathComponent("\(fileName!)")
        
        if fileManager.fileExists(atPath: fullPath.path){
            return true
        }else{
            return false
        }
    }
    
    func finishedDownloadImage() {
        imageDownloaded = true
        if audioDownloaded {
            self.delegate?.finishedDownload()
        }
    }
    
    func finishedDownloadAudio() {
        audioDownloaded = true
        if imageDownloaded {
            self.delegate?.finishedDownload()
        }
    }
    
    func startDownload() {
        //Download Image into local file
        var downloadImages = [String: String]()
        var downloadAudios = [String: String]()
        for lesson in listVocabulary {
            //check is exist file in level
            if !isDataExist(levelName: name, fileName: "\(lesson.name).png"){
                downloadImages.updateValue(lesson.image!, forKey: lesson.name)
            }
            
            if !isDataExist(levelName: name, fileName: "\(lesson.name).mp3"){
                downloadAudios.updateValue(lesson.audio!, forKey: lesson.name)
            }
        }
        
        if !downloadImages.isEmpty{
            let imageDownload = ImageDownLoad(downloadImages: downloadImages)
            imageDownload.downloadImage(levelName: self.name) { (isFinishedDowloadImage) in
                if isFinishedDowloadImage {
                    self.finishedDownloadImage()
                }
            }
            
        }

        if !downloadAudios.isEmpty{
            let audioDownload = AudioDownload(downloadAudios: downloadAudios)
            audioDownload.downloadAudio(levelName: self.name) { (isFinishedDowloadAudio) in
                if isFinishedDowloadAudio {
                    self.finishedDownloadAudio()
                }
            }
        }
        
        if (downloadAudios.isEmpty && downloadImages.isEmpty){
            self.delegate?.finishedDownload()
        }
    }
}
