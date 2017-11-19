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
import SAConfettiView

enum AlertPopupType: Int {
    case TimeLimit = 0
    case OutOfHearts
    case PassLesson
    case None
}

protocol LessonViewControllerDelegate {
    func showTypingQuiz(levelName: String)
}

class LessonViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LessonViewCellDelegate, AudioPlayerDelegate, DownloadFileDelegate, MoveAnimationViewDelegate {
    
    private var maxfailed = 0
    private var viewNumber = 0
    private var durationLesson: Double?
    private var level: Int?
    private var keyID: String!
    private var name: String?
    private var numImageFirst: Int = 2
    private var numsView = 1
    private var anim = true
    
    private var numsFailed = 0 {
        didSet {
            if self.anim {
                lessonNavView.ratingControl.rating = 5 - numsFailed
                if numsFailed == maxfailed{
                    self.backToHome(alertType: .OutOfHearts, showPopup: true)
                }
            }
        }
    }
    
    private var alertView: SCLAlertView?
    @IBOutlet weak var lessonNavView: LessonNavView!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var colView: UICollectionView!
    
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
    
    var nextVocabularies: [LessonItem] = []
    var nextName: String?
    
    var audioPlayer: AudioPlayer!
    var keyName: String!
    
    var delegate: LessonViewControllerDelegate?

    func setup(maxfailed : Int, duration: Double, numImageFirstView: Int, name: String?, listVocabulary: Array<LessonItem>, nextName: String?, nextVocabularies: Array<LessonItem>) {
        self.maxfailed = maxfailed
        self.durationLesson = duration
        self.name = name
        self.numImageFirst = numImageFirstView
        self.listVocabulary = listVocabulary
        
        //Next level
        self.nextName = nextName
        self.nextVocabularies = nextVocabularies
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)

        lessonNavView.setup()
        lessonNavView.setTimeToFinished(duration: self.durationLesson!)
        lessonNavView.delegate = self
        
        self.labelView.layer.cornerRadius = keyLabel.layer.frame.size.height/2
        self.labelView.layer.borderWidth = 1.0
        self.labelView.layer.borderColor = UIColor(red: 211/255, green: 218/255, blue: 224/255, alpha: 1).cgColor
        
        colView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        colView.register(UINib(nibName: "LessonViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        colView.delegate   = self
        colView.dataSource = self
        
        kAppDelegate.bannerAdView.updateBannerFrame(pos: .NoTabbar)
        
        loadListVocabulary()
        self.audioPlayer = AudioPlayer()
        self.audioPlayer.delegate = self
        
        //Start first view
        nextView(numberImage: self.numImageFirst)
        Analytics.logEvent("Open Picture pickup", parameters: [
            "name": "Open Picture pickup" as NSObject,
            "text": "Click to Open Picture pickup" as NSObject
            ])
        
        //Download next level
        let downloadFile = DownloadFile(name: self.nextName, listVocabulary: self.nextVocabularies)
        downloadFile.delegate = self
        DispatchQueue.background(delay: 3.0, completion:{
            downloadFile.startDownload()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.bannerAdView.isTabbarShow = false
        
        self.navigationController?.navigationBar.isHidden = true
        if self.lessonNavView.countDownLabel.isPaused{
            lessonNavView.countDownLabel.start()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(Notification.Name.UIApplicationWillResignActive)
        notificationCenter.removeObserver(Notification.Name.UIApplicationDidBecomeActive)
        //Todo: Stop download
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
    
    func finishedDownload() {
       debugPrint("[Next Level] Finished download file from server side")
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
        
        let image = Helper.getImage(nameImage: item.name, nameFolder: self.name!)
        cell.imageLessonView.image = image
        cell.selectedView.isHidden = true
        
        return cell
    }
    
    var waterDropView: UIView!
    
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
                    
                    // Update score for user
                    score = defaults.integer(forKey: ScoreData)
                    let starCountSave = defaults.integer(forKey: userValue)

                    if (starCountSave != 0) && (score > starCountSave) {
                        score -= starCountSave
                        score += starCount
                    } else if (starCountSave == 0) {
                        score += starCount
                    }
                    
                    defaults.set(starCount, forKey: userValue)
                    defaults.set(score, forKey: ScoreData)
                    
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
            //animation image
            self.anim = false
            
            audioPlayer.playGameSounds(audio: Sound.failSounds!)
            
            let cell = colView.cellForItem(at: indexPath) as! LessonViewCell
            if cell.selectedView.isHidden == true{
                numsFailed += 1
            }
            
            cell.setSelectedView(bool: false)
            
            let to = self.lessonNavView.ratingControl.getPositionStar(index: maxfailed - numsFailed)
            let toPoint = self.lessonNavView.ratingControl.convert(to, to: self.view)
            
            let from = CGPoint(x: cell.selectedView.frame.midX, y: cell.selectedView.frame.midY)
            let fromPoint = cell.convert(from, to: self.view)
            
            // custom configuration
            let animationView = MoveAnimationView {
                $0.color = UIColor.red
                $0.startPoint = fromPoint
                $0.stopPoint = toPoint
                $0.startAnimation()
            }
            
            self.view.addSubview(animationView)
            animationView.bindFrameToSuperviewBounds()
            animationView.delegate = self
        }
    }
    // MARK: MoveAnimationViewDelegate
    func stopMoveAnimation() {
        self.anim = true
        lessonNavView.ratingControl.rating = 5 - numsFailed
        if numsFailed == maxfailed{
            self.backToHome(alertType: .OutOfHearts, showPopup: true)
        }
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpaceWidth = sectionInsets.left * (numOfItemInSection + 1)
        let availableWidth = colView.frame.width - paddingSpaceWidth
        
        let paddingSpaceHeight = sectionInsets.top * (numOfSections + 1)
        //var availableHeight = colView.frame.height - FontSizeCustom.getHeightOfBanner() - paddingSpaceHeight
        
        var availableHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            availableHeight = self.colView.safeAreaLayoutGuide.layoutFrame.height - FontSizeCustom.getHeightOfBanner() - paddingSpaceHeight
        } else {
            availableHeight = self.colView.frame.height - FontSizeCustom.getHeightOfBanner() - paddingSpaceHeight
        }
        
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
        self.cleanUp()
        if showPopup{
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
                //showCircularIcon: false
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
                showCongratulationsAnim(superView: (self.alertView?.view)!)
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
    
    func showCongratulationsAnim(superView: UIView) {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        superView.addSubview(confettiView)
        confettiView.bindFrameToSuperviewBounds()
        confettiView.intensity = 0.75
        confettiView.type = .Diamond
        confettiView.startConfetti()
        Helper.perfomDelay(time: 1.2) {
            confettiView.stopConfetti()
            confettiView.removeFromSuperview()
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
        self.cleanUp()
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
        
        if (numsFailed < maxfailed) && (numsFailed != 0) {
            //Load data from keyID
            let dictionaryVC = DictionaryViewController()
            let lessonItem = listVocabulary[Int(keyID)!]
            dictionaryVC.initDictionaryVC(lessonItem: lessonItem)
            self.navigationController?.pushViewController(dictionaryVC, animated: true)
        }
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
