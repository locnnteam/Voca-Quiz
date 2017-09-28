//
//  LessonViewController.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/17/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import SCLAlertView
import AlamofireImage
import FirebaseAnalytics

enum AlertPopupType: Int {
    case TimeLimit = 0
    case OutOfHearts
    case PassLesson
    case None
}

protocol LessonViewControllerDelegate {
    func showTypingQuiz(levelName: String)
}

class LessonViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LessonViewCellDelegate, AudioPlayerDelegate{
    
    private var maxfailed = 0
    private var viewNumber = 0
    private var durationLesson: Double?
    private var level: Int?
    private var keyID: String!
    private var name: String?
    private var numImageFirst: Int = 2
    
    private var numsView = 1
    private var numsFailed = 0 {
        didSet {
            lessonNavView.ratingControl.rating = 5 - numsFailed
            if numsFailed == maxfailed + 1{
                self.backToHome(alertType: .OutOfHearts, showPopup: true)
            }
        }
    }
    
    var colView: UICollectionView!
    private var alertView: SCLAlertView?
    @IBOutlet weak var lessonNavView: LessonNavView!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var labelView: UIView!
    
    
    let customNavigationAnimationController = CustomNavigationAnimationController()
    let customInteractionController = CustomInteractionController()
    let transitionVC = TransitionManager()
    
    private let reuseIdentifier = "Cell"
    private var numOfContents = 2
    private var numOfSections: CGFloat = 2
    private var numOfItemInSection: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private var currentNumImage: Int = 2

    var listVocabulary: [LessonItem] = []
    private var listVocabularyKey: [LessonItem] = []
    private var listVocabularyShow: [LessonItem?] = []
    
    var audioPlayer: AudioPlayer!
    var keyName: String!
    
    var delegate: LessonViewControllerDelegate?

    func setup(maxfailed : Int, duration: Double, numImageFirstView: Int, name: String?, listVocabulary: Array<LessonItem>) {
        self.maxfailed = maxfailed
        self.durationLesson = duration
        self.name = name
        self.numImageFirst = numImageFirstView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BackgroundColor.LessonBackground
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)

        lessonNavView.setup()
        lessonNavView.setTimeToFinished(duration: self.durationLesson!)
        lessonNavView.delegate = self
        
        self.labelView.layer.cornerRadius = keyLabel.layer.frame.size.height/2
        self.labelView.layer.borderWidth = 1.0
        self.labelView.layer.borderColor = UIColor(red: 211/255, green: 218/255, blue: 224/255, alpha: 1).cgColor
        self.labelView.layer.backgroundColor = UIColor.white.cgColor
        
        let layout = UICollectionViewFlowLayout()
        colView = UICollectionView(frame: CGRect(x: 0, y: 140, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 130), collectionViewLayout: layout)
        colView.delegate   = self
        colView.dataSource = self
        colView.backgroundColor = BackgroundColor.LessonBackground
        
        colView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        colView.register(UINib(nibName: "LessonViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.view.addSubview(colView)
        
        loadListVocabulary()
        self.audioPlayer = AudioPlayer()
        self.audioPlayer.delegate = self
        
        //Start first view
        nextView(numberImage: self.numImageFirst)
        Analytics.logEvent("Open Picture pickup", parameters: [
            "name": "Open Picture pickup" as NSObject,
            "text": "Click to Open Picture pickup" as NSObject
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.lessonNavView.countDownLabel.isPaused{
            lessonNavView.countDownLabel.start()
        }
        
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
            lessonNavView.countDownLabel.start()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loadListVocabulary(){
        //Setup list vocabulay to learn        
        self.listVocabularyKey = listVocabulary
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Int(numOfContents)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LessonViewCell

        guard let item = listVocabularyShow[indexPath.row] else {
            cell.imageLessonView.image = #imageLiteral(resourceName: "default")
            return cell
        }
        
        let image = getImage(nameImage: (item.name))
        cell.imageLessonView.image = image
        cell.selectedView.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listVocabularyShow[indexPath.row]?.id == self.keyID {
            let cell = colView.cellForItem(at: indexPath) as! LessonViewCell
            cell.setSelectedView(bool: true)
            audioPlayer.playGameSounds(audio: Sound.passSounds!)
            
            Helper.perfomDelay(time: 0.3){
                if self.listVocabularyKey.isEmpty{
                    //Pass all vocabulary
                    let defaults = UserDefaults.standard
                    let userValue = "picture_\(self.name!)"
                    let starCount = self.maxfailed - self.numsFailed + 1
                    defaults.set(starCount, forKey: userValue)
                    
                    self.backToHome(alertType: .PassLesson, showPopup: true)
                    return
                }
                
                //Next view item
                if self.numsView == 3 {
                    //Todo: Pass test
                    switch self.currentNumImage {
                    case 2:
                        self.nextView(numberImage: 4)
                    case 4:
                        if self.listVocabulary.count < 4 {
                            self.nextView(numberImage: 4)
                        }else{
                            self.nextView(numberImage: 6)
                        }
                    case 6:
                        if self.listVocabulary.count < 9 {
                            self.nextView(numberImage: 6)
                        }else{
                            self.nextView(numberImage: 9)
                        }
                    case 9:
                        if self.listVocabulary.count < 12 {
                            self.nextView(numberImage: 9)
                        }else{
                            self.nextView(numberImage: 12)
                        }
                    case 12:
                        self.nextView(numberImage: 12)
                    default:
                        fatalError("Not correct number of image")
                    }
                    self.numsView = 0
                }else{
                    self.nextView(numberImage: self.currentNumImage)
                }
                
                self.numsView += 1
                self.viewNumber += 1
                var average: Float = 0
                average = (Float (self.viewNumber) / Float(self.listVocabulary.count))
                self.lessonNavView.progressBar.setProgress(CGFloat(average), animated: true)
                
            }
            
        }else{
            audioPlayer.playGameSounds(audio: Sound.failSounds!)
            
            let cell = colView.cellForItem(at: indexPath) as! LessonViewCell
            if cell.selectedView.isHidden == true{
                numsFailed += 1
            }
            cell.setSelectedView(bool: false)
        }
        
    }
        
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpaceWidth = sectionInsets.left * (numOfItemInSection + 1)
        let availableWidth = colView.frame.width - paddingSpaceWidth
        
        let paddingSpaceHeight = sectionInsets.top * (numOfSections + 1)
        let availableHeight = colView.frame.height - paddingSpaceHeight
        
        let widthPerItem = availableWidth / numOfItemInSection
        let heightPerItem = availableHeight / numOfSections
        
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // MARK: Create image to show and key
    func nextView(numberImage: Int){
        listVocabularyShow.removeAll()
        for _ in 1...numberImage {
            listVocabularyShow.append(nil)
        }
        
        currentNumImage = numberImage
        setNumberOfImage(num: numberImage)
        
        //Get number of list image to show
        var nums = numberImage - 1
        var tempListVocabulary = listVocabulary
        
        //Add random key into random position to show
        let randomKey = Int(arc4random_uniform(UInt32(listVocabularyKey.count)))
        debugPrint(listVocabularyKey.count)
        let randomShowpos = Int(arc4random_uniform(UInt32(numberImage)))
        listVocabularyShow[randomShowpos] = listVocabularyKey[randomKey]
        self.keyID = listVocabularyKey[randomKey].id!
        
        //Remove key from list image to show
        for index in 0..<(tempListVocabulary.count){
            if tempListVocabulary[index].id == keyID{
                tempListVocabulary.remove(at: index)
                break
            }
        }
        
        while nums >= 0 {
            if listVocabularyShow[nums] == nil {
                if !tempListVocabulary.isEmpty{
                    let randomNum = Int(arc4random_uniform(UInt32(tempListVocabulary.count)))
                    listVocabularyShow[nums] = tempListVocabulary[randomNum]
                    tempListVocabulary.remove(at: Int(randomNum))
                }else{
                    listVocabularyShow[nums] = listVocabularyShow[0]
                }
            }
            nums -= 1
        }
        
        //Update UI
        self.keyName = listVocabularyKey[randomKey].name
        self.keyLabel.text = self.keyName
        self.playAudio(audio: self.keyName)
        
        listVocabularyKey.remove(at: randomKey)
        colView.reloadData()
    }
    
    func setNumberOfImage(num: Int?){
        if num == 2 {
            numOfContents = 2
            numOfSections = 2
            numOfItemInSection = 1
        }else if num == 4{
            numOfContents = 4
            numOfSections = 2
            numOfItemInSection = 2
        }else if num == 6{
            numOfContents = 6
            numOfSections = 3
            numOfItemInSection = 2
        }else if num == 9{
            numOfContents = 9
            numOfSections = 3
            numOfItemInSection = 3
        }else if num == 12{
            numOfContents = 12
            numOfSections = 4
            numOfItemInSection = 3
        }else{
            fatalError("Not correct number of image to show")
        }
    }
    
    func playAudio(audio: String){
        let filePath = DocumentsURL.appendingPathComponent("\(self.name!)/\(audio).mp3").path
        if FileManager.default.fileExists(atPath: filePath) {
            Helper.perfomDelay(time: 0.2){
                self.audioPlayer.playAudioLocal(audio: filePath)
            }
        }
    }
    
    func rePlayAudio(audio: String){
        let filePath = DocumentsURL.appendingPathComponent("\(self.name!)/\(audio).mp3").path
        if FileManager.default.fileExists(atPath: filePath) {
            self.audioPlayer.playAudioLocal(audio: filePath)
        }
    }
    
    // MARK: Controller view cycle
    // ca-app-pub-7818146390468896/9219733068
    func backToHome(alertType: AlertPopupType, showPopup: Bool) {
        //clean up and show alert
        cleanUp()
        if showPopup{
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false,
                showCircularIcon: false
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
                alertView?.addButton("Yes", action: {self.buttonYesTapped()})
                alertView?.addButton("No", action: {self.buttonDoneTapped()})
                alertView?.showSuccess("Congratulation!", subTitle: "You are passed lesson \(self.name!). Do you like typing quiz ?")
            default:
                print("No define alert type")
            }
            
            kAppDelegate.showInterstialAd(adRootVC: self)
            
        }else{
            guard (navigationController?.popViewController(animated:true)) != nil
                else {
                    dismiss(animated: true, completion: nil)
                    return
            }
        }
    }
    
    func buttonYesTapped() {
        dismiss(animated: false, completion: nil)
        self.delegate?.showTypingQuiz(levelName: self.name!)
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
        nextView(numberImage: self.numImageFirst)
        lessonNavView.setTimeToFinished(duration: self.durationLesson!)
        lessonNavView.progressBar.setProgress(0, animated: true)
        lessonNavView.ratingControl.rating = 5
    }
    
    func cleanUp(){
        numsFailed = 0
        numsView = 1
        viewNumber = 0
        lessonNavView.countDownLabel.cancel()
        audioPlayer.stopAudioLocal()
        
    }
    
    func pauseLessonTest() {
        
    }
    
    func finishedGameSouds(successfully flag: Bool){

    }
    
    @IBAction func audioButtonTapped(_ sender: Any) {
        self.rePlayAudio(audio: self.keyName)
    }
    
    @IBAction func translateButtonTapped(_ sender: Any) {
        self.numsFailed += 1
        self.lessonNavView.countDownLabel.pause()
        
//        self.colView.isHidden = true
//        self.labelView.isHidden = true
//
//        self.dictionaryView.delegate = self
//        self.dictionaryView.isHidden = false
//        self.dictionaryView.fadeIn(duration: 0.1)
//
        //Load data from keyID
        let dictionaryVC = DictionaryViewController()
        let lessonItem = listVocabulary[Int(keyID)!]
        dictionaryVC.initDictionaryVC(lessonItem: lessonItem)
        self.navigationController?.pushViewController(dictionaryVC, animated: true)
    }
}

extension LessonViewController: DictionaryViewDelegate{
    func audioDictPlay(audio: String?){
        self.playAudio(audio: audio!)
    }
    func favoriteDictAdd(word: String?){
        
    }
}

extension LessonViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            customInteractionController.attachToViewController(toVC)
        }
        customNavigationAnimationController.reverse = operation == .pop
        return customNavigationAnimationController
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteractionController.transitionInProgress ? customInteractionController : nil
    }
    
}
