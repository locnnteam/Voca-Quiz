//
//  DictionaryView.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 9/17/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import FaveButton

protocol DictionaryViewDelegate {
    func audioDictPlay(audio: String?)
    func favoriteDictAdd(word: String?)
}
class DictionaryView: UIView {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var definationLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var spellingLabel: UILabel!
    
    var word: String!
    var spelling: String?
    var defination: String?
    var example: String?
    var delegate: DictionaryViewDelegate!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let height = UIScreen.main.bounds.height - 64
        let width = UIScreen.main.bounds.width
        self.frame = CGRect(x: 0, y: 64, width: width, height: height)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DictionaryView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func loadDataDictionaryView(lessonItem: LessonItem){
        self.word = lessonItem.name
        self.spelling = lessonItem.spelling
        self.defination = lessonItem.defination
        self.example = lessonItem.example
        
        self.wordLabel.text = self.word
        self.spellingLabel.text = "[" + spelling! + "]"
        
        guard let defination = defination else {
            return
        }
        self.definationLabel.text = "➭ \(self.word!): " + defination
        
        guard let example = example else {
            return
        }
        let str = "➥ Example: " + example
        self.exampleLabel.text = str
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        self.delegate.favoriteDictAdd(word: self.word)
    }
    @IBAction func audioButtonTapped(_ sender: Any) {
        self.delegate.audioDictPlay(audio: self.word)
    }
}
