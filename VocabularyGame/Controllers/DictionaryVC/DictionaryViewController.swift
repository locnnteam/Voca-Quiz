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
    let coreData: CoreDataOperations = CoreDataOperations()
    
    var word: String!
    var defination: String?
    var spelling: String?
    var example: String?
    
    func initDictionaryVC(lessonItem: LessonItem){
        self.word = lessonItem.name
        self.defination = lessonItem.defination
        self.spelling = lessonItem.spelling
        self.example = lessonItem.example
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dictionaryView.delegate = self
        self.dictionaryView.loadDataDictionaryView(word: self.word, spelling: self.spelling, defination: self.defination, example: self.example)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        //Seleted favorite
        let favorites = coreData.fetchData()
        for fav in favorites {
            if self.word == fav.value(forKeyPath: "name") as? String {
                self.dictionaryView.favoriteButton.isSelected = true
                break
            }
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
        
    }
    
    func favoriteDictAdd(word: String?) {
        if self.dictionaryView.favoriteButton.isSelected {
            coreData.delete(name: word!)
            self.dictionaryView.favoriteButton.isSelected = false
        } else {
            self.dictionaryView.favoriteButton.isSelected = true
            coreData.save(name: word!)
        }
    }
}
