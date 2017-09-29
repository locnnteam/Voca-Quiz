//
//  FavoritesTableViewCell.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/1/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
protocol FavoritesTableViewCellDelgate {
    func favoriteDictRemove(lessonItem: LessonItem)
}

class FavoritesTableViewCell: UITableViewCell {
    var frontView = FrontView()
    var backView = BackView()
    var audioPlayer: AudioPlayer!
    var lessonItem: LessonItem!
    var coreData: CoreDataOperations!
    var delegate: FavoritesTableViewCellDelgate!
    @IBOutlet weak var FlashCardView: UIView!
    
    var showingBack: Bool = false {
        didSet {
            backView.isHidden = !showingBack
            frontView.isHidden = showingBack
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.FlashCardView.addFitSubView(subView: self.frontView)
        self.FlashCardView.addFitSubView(subView: self.backView)
        self.showingBack = false
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
        singleTap.numberOfTapsRequired = 1
        self.FlashCardView.addGestureRecognizer(singleTap)
    }

    func flip() {
        // Configure the view for the selected state
        let toView = self.showingBack ? self.frontView : self.backView
        let fromView = self.showingBack ? self.backView : self.frontView
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
        toView.translatesAutoresizingMaskIntoConstraints = true
        showingBack = !showingBack
    }
    
    func initDataFavoriteCell(lessonItem: LessonItem){
        self.lessonItem = lessonItem
        let levelName = lessonItem.levelName
        let image = Helper.getImage(nameImage: lessonItem.name, nameFolder: levelName)
        //setup flashcard data
        self.frontView.imageView.image = image
        self.frontView.definationLabel.text = lessonItem.defination
        self.backView.wordLabel.text = lessonItem.name
        //Todo: setup favorites icon
        coreData = CoreDataOperations()
        let isFavorites = coreData.iskExistObject(word: self.lessonItem.name)
        self.frontView.favoritesButton.isSelected = isFavorites
        self.backView.favoritesButton.isSelected = isFavorites
        
        self.frontView.delegate = self
        self.backView.delegate = self
        
        self.audioPlayer = AudioPlayer()
    }
}

extension FavoritesTableViewCell: FrontViewDelegate, BackViewDelegate {
    func audioDictPlay() {
        replayAudio()
    }
    
    func favoriteDictAdd() {
        if self.frontView.favoritesButton.isSelected {
            coreData.deleteRecords(lessonItem: lessonItem)
            self.frontView.favoritesButton.isSelected = false
            delegate.favoriteDictRemove(lessonItem: lessonItem)
        } else {
            self.frontView.favoritesButton.isSelected = true
            coreData.saveData(lessonItem: lessonItem)
        }
        
        if self.backView.favoritesButton.isSelected {
            coreData.deleteRecords(lessonItem: lessonItem)
            self.backView.favoritesButton.isSelected = false
            delegate.favoriteDictRemove(lessonItem: lessonItem)
        } else {
            self.backView.favoritesButton.isSelected = true
            coreData.saveData(lessonItem: lessonItem)
        }
    }
    
    func replayAudio() {
        let audioFileName = self.lessonItem.name
        let levelName = self.lessonItem.levelName
        
        let filePath = DocumentsURL.appendingPathComponent("\(levelName)/\(audioFileName).mp3").path
        if FileManager.default.fileExists(atPath: filePath) {
            audioPlayer.playAudioLocal(audio: filePath)
        }
    }
}
