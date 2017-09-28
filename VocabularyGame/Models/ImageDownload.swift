//
//  ImageDownload.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 7/8/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import AlamofireImage
import Alamofire

@objc protocol ImageDownLoadDelegate{
    func finishedDownloadImage()
}

class ImageDownLoad {
    var images = [String: String]() //location: url
    var delegate: ImageDownLoadDelegate?
    var numOfImage = 0
    
    init(downloadImages: Dictionary<String, String>) {
        self.images = downloadImages
        self.numOfImage = downloadImages.count
    }
    
    func downloadImage(levelName: String?, completion: @escaping (_ isFinishedDowloadImage: Bool) -> Void){
        var isFinishedDowloadImage = false
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
        
        for image in images {
            //Start download all image
            
//            let safeURL =  image.value
//            let url = safeURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            let url = image.value
            guard let imageUrl = URL(string: url) else{
                print("imageUrl is nil")
                continue
            }
            
            Alamofire.request(imageUrl, method: .get).responseImage { response in
                guard let imageLocal = response.result.value else {
                    // Handle error
                    return
                }
                // Do stuff with your image
                let fileName = image.key
                do {
                    let fileURL = DocumentsURL.appendingPathComponent("\(_levelName)/\(fileName).png")
                    if let pngImageData = UIImagePNGRepresentation(imageLocal) {
                        self.numOfImage -= 1
                        //finish download
                        if self.numOfImage == 0 {
                            isFinishedDowloadImage = true
                        }
                        try pngImageData.write(to: fileURL, options: .atomic)
                    }
                    
                } catch { }
                completion(isFinishedDowloadImage)
            }
        }
    }
}
