//
//  HomeCollectionViewController.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 8/10/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import FirebaseAnalytics
import SCLAlertView

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, DownloadFileDelegate, HeaderMainViewDelegate, LessonViewControllerDelegate {
    private let reuseIdentifier = "Cell"
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    private var lastLessonsPassed: Int = 0
    
    private var levels: [Level] = []
    private var lessonVC: LessonViewController?
    private var lessonTyping: LessonTypingViewController?
    var isMainView = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.bannerAdView.isTabbarShow = true
        
        UIApplication.shared.statusBarStyle = .lightContent
        kAppDelegate.bannerAdView.updateBannerFrame(pos: .HaveTabbar)
        
        LoadingOverlay.shared.hideOverlayView()
        self.collectionView?.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LoadingLaunchView.shared.hideOverlayView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadHomeData()
        LoadingLaunchView.shared.showOverlay(view: self.view)
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "HomeContentViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //UI
        self.collectionView?.backgroundColor = BackgroundColor.HomeBackground
        
        //firebase analyst
        Analytics.logEvent("Open App", parameters: [
            "name": "Open App" as NSObject,
            "text": "Click to open app" as NSObject
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadHomeData(){
        LessonModel.loadLessonData(lessonURL: FireBaseURL.jsonHomeDataURL) { (levelItems) in
            if levelItems.count > 0{
                self.levels = levelItems.sorted(by: { Int($0.levelPriority!)! < Int($1.levelPriority!)! })
                LoadingLaunchView.shared.hideOverlayView()
                self.collectionView?.reloadData()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Navigation
    func selectedMenuItem(index: Int) {
        if index == 0 {
            self.isMainView = true
        }
        else if index == 1 {
            self.isMainView = false
        }
        
        self.collectionView?.reloadData()
        self.collectionView?.setContentOffset(CGPoint.zero, animated: false)
    }
    
    // MARK: LessonDelegate
    func showTypingQuiz(levelName: String) {
        var level = self.levels[0]
        for index in 1..<self.levels.count {
            let prevLevel = self.levels[index - 1]
            let defaults = UserDefaults.standard
            
            let userValue = "typing_\(prevLevel.levelName!)"
            let starCount = defaults.integer(forKey: userValue)
            
            if starCount != 0 {
                level = levels[index]
            }
        }
        self.lessonTyping = LessonTypingViewController()
        self.lessonTyping?.setup(maxfailed: 5, duration: level.levelTime,
                                 name: level.levelName, listVocabulary: level.listVocabulary)
        present(self.lessonTyping!, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return levels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HomeContentViewCell
    
        // Configure the cell
        //cell label style
        cell?.changeLabelStyle(isEdit: !isMainView)
        if indexPath.row < levels.count {
            let level = levels[indexPath.row]
            let defaults = UserDefaults.standard
            cell?.lessonLevelLabel.text = level.levelName
            
            let urlImg = URL(string: level.levelThumnail!)
            cell?.lessonImage.af_setImage(withURL: urlImg!)
            cell?.lockView.isHidden = false
            
            var userValue: String?
            if isMainView{
                userValue = "picture_\(level.levelName!)"
            }else{
                userValue = "typing_\(level.levelName!)"
            }
            
            let starCount = defaults.integer(forKey: userValue!)
            if starCount != 0 {
                cell?.ratingControll.rating = starCount - 1
                cell?.lockView.isHidden = true
                return cell!
            }
            
            if indexPath.row == 0 {
                cell?.ratingControll.rating = 0
                cell?.lockView.isHidden = true
            }else{
                let prevLevel = levels[indexPath.row - 1]
                let defaults = UserDefaults.standard
                
                var userValue: String?
                if isMainView{
                    userValue = "picture_\(prevLevel.levelName!)"
                }else{
                    userValue = "typing_\(prevLevel.levelName!)"
                }
                
                let starCount = defaults.integer(forKey: userValue!)
                if starCount != 0 {
                    self.lastLessonsPassed = indexPath.row
                    cell?.ratingControll.rating = 0
                    cell?.lockView.isHidden = true
                }
            }
        }
        return cell!
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let index = indexPath.row
        var level: Level!
        let nextLevel: Level = index < (levels.count - 1) ? levels[index + 1] : levels[index]
        
        if indexPath.row == 0 {
            level = levels[indexPath.row]
        } else {
            let prevLevel = levels[indexPath.row - 1]
            let defaults = UserDefaults.standard
            
            var userValue: String?
            if isMainView{
                userValue = "picture_\(prevLevel.levelName!)"
            }else{
                userValue = "typing_\(prevLevel.levelName!)"
            }
            let starCount = defaults.integer(forKey: userValue!)
            if starCount != 0 {
                level = levels[indexPath.row]
            }else{
                //Todo: Animation and show alert msg
                let appearance = SCLAlertView.SCLAppearance(
                    showCircularIcon: true
                )
                let alertView = SCLAlertView(appearance: appearance)
                let alertViewIcon = #imageLiteral(resourceName: "lockLevel")
                
                let subTit = "Ohh, let play the \"\(self.levels[lastLessonsPassed].levelName!)\" first"
                alertView.showInfo("Locked", subTitle: subTit, circleIconImage: alertViewIcon)
                return true
            }
            
            level = levels[indexPath.row]
        }
        
        if isMainView {
            self.lessonVC = LessonViewController()
            self.lessonVC?.delegate = self
            self.lessonVC?.setup(maxfailed: 5, duration: level.levelTime, numImageFirstView: level.levelNumberRamdom, name: level.levelName, listVocabulary: level.listVocabulary, nextName: nextLevel.levelName, nextVocabularies: nextLevel.listVocabulary)
        } else {
            self.lessonTyping = LessonTypingViewController()
            self.lessonTyping?.setup(maxfailed: 5, duration: level.levelTime, name: level.levelName, listVocabulary: level.listVocabulary)
        }
        //Start download file
        let downloadFile = DownloadFile(name: level.levelName, listVocabulary: level.listVocabulary)
        downloadFile.delegate = self
        downloadFile.startDownload()
        LoadingOverlay.shared.showOverlay(view: self.view)
        
        return true
    }
    
    func finishedDownload() {
        debugPrint("Finished download file from server side")
        LoadingOverlay.shared.hideOverlayView()
        if isMainView{
            //self.navigationController?.pushViewController(self.lessonVC!, animated: true)
            let nav = UINavigationController(rootViewController: self.lessonVC!)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }else{
            let nav = UINavigationController(rootViewController: self.lessonTyping!)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem - 10.0)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

}
