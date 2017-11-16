//
//  DictionaryViewController.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 9/24/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

class DictionaryViewController: UIViewController {
    @IBOutlet weak var dictionaryView: DictionaryView!
    var lessonItem: LessonItem!
    var audioPlayer = AudioPlayer()
    
    func initDictionaryVC(lessonItem: LessonItem){
        self.lessonItem = lessonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dictionaryView.delegate = self
        self.dictionaryView.loadDataDictionaryView(lessonItem: self.lessonItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.bannerAdView.isTabbarShow = false
        
        self.navigationController?.navigationBar.isHidden = true
        
        let isFavorites = CoreDataOperations().iskExistObject(word: self.lessonItem.name)
        self.dictionaryView.favoriteButton.isSelected = isFavorites
    }

    override var prefersStatusBarHidden: Bool {
        if #available(iOS 11.0, *) { // check for iOS 11.0 and later
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Navigation
    @IBAction func backButtonTapped(_ sender: Any) {
        guard (navigationController?.popViewController(animated:true)) != nil
            else {
                dismiss(animated: true, completion: nil)
                return
        }
    }
}

extension DictionaryViewController: DictionaryViewDelegate {
    func audioDictPlay(audio: String?) {
        let audioName = self.lessonItem.name
        let levelName = self.lessonItem.levelName
        
        let filePath = DocumentsURL.appendingPathComponent("\(levelName)/\(audioName).mp3").path
        if FileManager.default.fileExists(atPath: filePath) {
            audioPlayer.playAudioLocal(audio: filePath)
        }
    }
    
    func favoriteDictAdd(word: String?) {
        if self.dictionaryView.favoriteButton.isSelected {
            CoreDataOperations().saveData(lessonItem: self.lessonItem)
        } else {
            CoreDataOperations().deleteRecords(lessonItem: self.lessonItem)
        }
    }
}
