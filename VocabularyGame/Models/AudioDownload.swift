//
//  AudioDownload.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 7/8/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyXMLParser
import SwiftyJSON


class AudioDownload{
    var audios = [String: String]()
    var numOfAudio = 0
    
    init(downloadAudios: Dictionary<String, String>) {
        self.audios = downloadAudios
        self.numOfAudio = downloadAudios.count
    }
    
    //func downloadAudio(levelName: String?) {
    func downloadAudio(levelName: String?, completion: @escaping (_ isFinishedDowloadAudio: Bool) -> Void){
        var isFinishedDowloadAudio = false
        //create folder with name=levelname
        guard let _levelName = levelName else {
            fatalError("nil level name")
        }
        
        let folderPath = DocumentsURL.appendingPathComponent("\(_levelName)")
        do{
            try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        for audio in audios {
            //Start download all audio file
            let audioUrl = URL(string: audio.value)
            
            let fileName = audio.key
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = DocumentsURL
                
                // the name of the file here I kept is yourFileName with appended extension
                documentsURL.appendPathComponent("\(_levelName)/\(fileName).mp3")
                return (documentsURL, [.removePreviousFile])
            }
            
            Alamofire.download(audioUrl!, to: destination).response { response in
                if response.destinationURL != nil {
                    self.numOfAudio -= 1
                    //finish download
                    if self.numOfAudio == 0 {
                        isFinishedDowloadAudio = true
                    }
                }
                completion(isFinishedDowloadAudio)
            }
            
        }
    }
}
