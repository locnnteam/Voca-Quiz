//
//  LessonTypingViewController.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 8/5/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import AVFoundation
import SCLAlertView
import AlamofireImage
import FirebaseAnalytics
import Spring

class LessonTypingViewController: UIViewController, LessonViewCellDelegate, AudioPlayerDelegate {
    
    private var maxfailed = 0
    private var viewNumber = 0
    private var durationLesson: Double?
    private var level: Int?
    var result = false
    var name: String?
    var keyName: String?
    var keyID: String!
    private var numsView = 0
    var numsFailed = 0 {
        didSet {
            lessonNavView.ratingControl.rating = 5 - numsFailed
            if numsFailed == maxfailed + 1 {
                self.backToHome(alertType: .OutOfHearts, showPopup: true)
            }
        }
    }
    
    private var alertView: SCLAlertView?
    
    @IBOutlet weak var lessonNavView: LessonNavView!
    @IBOutlet weak var inputTextView: InputTextView!
    @IBOutlet weak var passImageView: SpringImageView!
    
    @IBOutlet weak var flashCardView: UIView!
    var coreData = CoreDataOperations()
    
    var imageView: UIImageView!
    var definationView: FlashCardView!
    
    var showingBack: Bool = false {
        didSet {
            imageView.isHidden = showingBack
            definationView.isHidden = !showingBack
        }
    }

    var audioPlayer: AudioPlayer!

    var listVocabulary: [LessonItem] = []
    private var listVocabularyKey: [LessonItem] = []
    private var listVocabularyShow: [LessonItem?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lessonNavView.setup()
        self.lessonNavView.setTimeToFinished(duration: self.durationLesson!)
        self.lessonNavView.delegate = self
        
        loadListVocabulary()
        
        self.audioPlayer = AudioPlayer()
        self.audioPlayer.delegate = self
        
        //firebase analyst
        Analytics.logEvent("Open Typing quiz", parameters: [
            "name": "Open Typing quiz" as NSObject,
            "text": "Click to Open Typing quiz" as NSObject
            ])
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        //Flashcard
        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleAspectFit
        self.flashCardView.addCustomSubView(subView: self.imageView, topConstant: 40.0, leadingConstant: 40.0, bottomConstant: 40.0, trailingConstant: 40.0)
        
        self.definationView = FlashCardView()
        self.definationView.delegate = self
        self.definationView.contentMode = .center
        self.flashCardView.addFitSubView(subView: self.definationView)
        
        self.showingBack = false
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
        singleTap.numberOfTapsRequired = 1
        self.flashCardView.addGestureRecognizer(singleTap)
        
        nextView()
        
        guard let defination = self.listVocabulary[Int(self.keyID)!].defination else {
            return
        }
        self.definationView.defination.text = defination
        let isFavorites = coreData.iskExistObject(word: self.keyName!)
        self.definationView.favoriteButton.isSelected = isFavorites
    }
    
    func flip() {
        let toView = self.showingBack ? self.imageView : self.definationView
        let fromView = self.showingBack ? self.definationView : self.imageView
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
        toView.translatesAutoresizingMaskIntoConstraints = true
        showingBack = !showingBack
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(Notification.Name.UIApplicationWillResignActive)
        notificationCenter.removeObserver(Notification.Name.UIApplicationDidBecomeActive)
        
    }
    
    func appMovedToBackground() {
        if self.lessonNavView.countDownLabel.isCounting {
            self.lessonNavView.countDownLabel.pause()
        }
    }
    
    func appMovedToActive() {
        if self.lessonNavView.countDownLabel.isPaused{
            self.lessonNavView.countDownLabel.start()
        }
    }
    
    func setup(maxfailed : Int, duration: Double, name: String?, listVocabulary: Array<LessonItem>) {
        self.maxfailed = maxfailed
        self.durationLesson = duration * 1.7
        self.name = name
        self.listVocabulary = listVocabulary
    }
    
    func getImage(nameImage: String) -> UIImage {
        let filePath = DocumentsURL.appendingPathComponent("\(self.name!)/\(nameImage).png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)!
        }else{
            return #imageLiteral(resourceName: "default")
        }
    }
 
    override var prefersStatusBarHidden: Bool {
        if #available(iOS 11.0, *) { // check for iOS 11.0 and later
            return false
        } else {
            return true
        }
    }
    
    func loadListVocabulary(){
        self.listVocabularyKey = listVocabulary
    }
    
    // MARK: Create image to show and key
    func nextView(){
        self.passImageView.isHidden = true
        if self.listVocabularyKey.isEmpty {
            //Next lesson
            self.backToHome(alertType: .PassLesson, showPopup: true)
            let defaults = UserDefaults.standard
            let userValue = "typing_\(self.name!)"
            defaults.set(maxfailed - numsFailed + 1, forKey: userValue)
            return
        }
        
        let randomKey = Int(arc4random_uniform(UInt32(listVocabularyKey.count)))
        self.keyID = self.listVocabulary[randomKey].id!
        //setup view
        self.imageView.image = getImage(nameImage: listVocabularyKey[randomKey].name)
        
        self.keyName =  listVocabularyKey[randomKey].name
        self.inputTextView.wordKey = keyName!
        let audioFileName = self.keyName!
        let filePath = DocumentsURL.appendingPathComponent("\(self.name!)/\(audioFileName).mp3").path
        if FileManager.default.fileExists(atPath: filePath) {
            Helper.perfomDelay(time: 0.2){
                self.audioPlayer.playAudioLocal(audio: filePath)
            }
        }
        
        listVocabularyKey.remove(at: randomKey)
        inputTextView.setupButtons()
        inputTextView.delegate = self
        
        viewNumber += 1
        var average: Float = 0
        average = (Float (viewNumber) / Float(listVocabulary.count))
        lessonNavView.progressBar.setProgress(CGFloat(average), animated: true)
    }
    
    // MARK: Controller view cycle
    func backToHome(alertType: AlertPopupType, showPopup: Bool) {
        //clean up and show alert
        self.view.endEditing(true)
        cleanUp()
        
        if showPopup{
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            if alertView != nil {
                alertView?.hideView()
            }
            alertView = SCLAlertView(appearance: appearance)
            
            switch alertType {
            case .TimeLimit:
                alertView?.addButton("Try Again", action: {self.buttonTryAgainTapped()})
                alertView?.addButton("Home", action: {self.buttonDoneTapped()})
                alertView?.showError("Try Again", subTitle: "Time is limited !")
            case .OutOfHearts:
                alertView?.addButton("Try Again", action: {self.buttonTryAgainTapped()})
                alertView?.addButton("Home", action: {self.buttonDoneTapped()})
                alertView?.showError("Try Again", subTitle: "You are out of STARS !")
            case .PassLesson:
                alertView?.addButton("Done", action: {self.buttonDoneTapped()})
                alertView?.showSuccess("Congratulation!", subTitle: "You are passed lesson \(self.name!)")
            default:
                print("No define alert type")
            }
            
        }else{
            guard (navigationController?.popViewController(animated:true)) != nil
                else {
                    dismiss(animated: true, completion: nil)
                    return
            }
        }
    }
    
    func buttonDoneTapped() {
        guard (navigationController?.popViewController(animated:true)) != nil
            else {
                dismiss(animated: true, completion: nil)
                return
        }
    }
    
    func buttonTryAgainTapped() {
        loadListVocabulary()
        lessonNavView.setTimeToFinished(duration: self.durationLesson!)
        lessonNavView.progressBar.setProgress(0, animated: true)
        lessonNavView.ratingControl.rating = 5
        nextView()
    }
    
    func cleanUp(){
        numsFailed = 0
        numsView = 0
        viewNumber = 0
        lessonNavView.countDownLabel.cancel()
        audioPlayer.stopAudioLocal()
        
    }
    
    func pauseLessonTest() {
        
    }
    
    
    // MARK: Gameaudio delegate
    func finishedGameSouds(successfully flag: Bool){
        if result {
            nextView()
        }
    }
}

extension LessonTypingViewController: InputTextDelegate{
    // MARK: Delegate from Keyboard
    func inputTextCorrect(isCorrect: Bool) {
        passImageView.isHidden = false
        if isCorrect{
            result = true
            audioPlayer.playGameSounds(audio: Sound.passSounds!)
            passImageView.image = #imageLiteral(resourceName: "typingPass")
            passImageView.animation = "zoomIn"
            passImageView.animate()
            //Reset data
            
        }else{
            result = false
            audioPlayer.playGameSounds(audio: Sound.failSounds!)
            passImageView.image = #imageLiteral(resourceName: "typingFail")
            passImageView.animation = "shake"
            passImageView.animate()
        }
    }
    
    func replayAudio() {
        guard let audioFileName = keyName else {
            fatalError("Not correct audio file name")
        }
        let filePath = DocumentsURL.appendingPathComponent("\(self.name!)/\(audioFileName).mp3").path
        if FileManager.default.fileExists(atPath: filePath) {
            audioPlayer.playAudioLocal(audio: filePath)
        }
    }
    
    func showIconPass(isShow: Bool) {
        passImageView.isHidden = !isShow
    }
    
    func helpButtonTapped(){
        numsFailed += 1
    }
}

extension LessonTypingViewController: FlashCardViewDelegate {
    func audioDictPlay() {
        self.replayAudio()
    }
    
    func favoriteDictAdd() {
        let lessonItem = listVocabulary[Int(self.keyID)!]
        if self.definationView.favoriteButton.isSelected {
            coreData.saveData(lessonItem: lessonItem)
        } else {
            coreData.deleteRecords(lessonItem: lessonItem)
        }
    }
}


