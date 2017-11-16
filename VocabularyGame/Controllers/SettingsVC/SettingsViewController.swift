//
//  SettingsViewController.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/25/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import SCLAlertView
import FacebookShare
import GameKit

class SettingsViewController: UIViewController {
    enum ItemLabel: String {
        case score = "Your score"
        case ranking = "Game ranking"
        case rate = "Rate us!"
        case fbShare = "Share on Facebook"
        case appVersion = "App version"
    }
    
<<<<<<< HEAD
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
=======
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    var score = 0
>>>>>>> 16988760ae68f9ad50819178b85c8bb975ffbbff
    var isAuthenticateLocal: Bool = false
    
    let AppID = "id1278800758"
    let AppURL = "https://itunes.apple.com/vn/app/voca-quiz/id1278800758?mt=8"
    
    var sections: [Int: Any?] = [:]
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // This will remove extra separators from tableview
        self.settingsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        
        self.loadSettingsItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSettingsItem() {
        //Todo: Score
        score = UserDefaults.standard.integer(forKey: ScoreData)
        guard let score = SettingsItem(label: ItemLabel.score.rawValue, photo: nil) else {
            fatalError("Unable to instantiate your score")
        }
        
        guard let ranking = SettingsItem(label: ItemLabel.ranking.rawValue, photo: nil) else {
            fatalError("Unable to instantiate ranking")
        }
        self.sections.updateValue([score, ranking], forKey: 0)
        
        //Todo: Section social
        guard let rateUs = SettingsItem(label: ItemLabel.rate.rawValue, photo: #imageLiteral(resourceName: "rateApp")) else {
            fatalError("Unable to instantiate rateUs")
        }
        
        guard let shareFB = SettingsItem(label: ItemLabel.fbShare.rawValue, photo: #imageLiteral(resourceName: "facebook")) else {
            fatalError("Unable to instantiate shareFB")
        }
        
        self.sections.updateValue([rateUs, shareFB], forKey: 1)
        
        //Todo: Section appversion
        guard let appVersion = SettingsItem(label: ItemLabel.appVersion.rawValue, photo: #imageLiteral(resourceName: "appInfo")) else {
            fatalError("Unable to instantiate appversion")
        }
        self.sections.updateValue([appVersion], forKey: 2)
    }
    
    fileprivate func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SettingsTableViewCell"

        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SettingsTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableViewCell
            
        }
        
        // Fetches the appropriate meal for the data source layout.
        let items = self.sections[indexPath.section] as! [SettingsItem]
        cell?.label.text = items[indexPath.row].label
        cell?.settingsImage.image = items[indexPath.row].photo
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = self.sections[section] as! [SettingsItem]
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let items = self.sections[indexPath.section] as! [SettingsItem]
        let label = items[indexPath.row].label
        
        switch label {
        case ItemLabel.ranking.rawValue:
<<<<<<< HEAD
            if score == 0 {
                score = UserDefaults.standard.integer(forKey: ScoreData)
            }
            
            if self.isAuthenticateLocal {
                self.addScoreAndSubmitToGC(score: score)
                self.checkGCLeaderboard()
            } else {
                LoadingLaunchView.shared.showOverlay(view: self.view)
=======
            if self.isAuthenticateLocal {
                self.checkGCLeaderboard()
            } else {
>>>>>>> 16988760ae68f9ad50819178b85c8bb975ffbbff
                self.authenticateLocalPlayer()
            }
            kAppDelegate.bannerAdView.isTabbarShow = false
            kAppDelegate.bannerAdView.updateBannerFrame(pos: .NoTabbar)
            break
        case ItemLabel.score.rawValue:
            let alertView = SCLAlertView()
<<<<<<< HEAD
            if score == 0 {
                score = UserDefaults.standard.integer(forKey: ScoreData)
            }
            alertView.showSuccess("Your score", subTitle: "\(score) points")
//            showCongratulationsAnim(superView: alertView.view)
=======
            alertView.showSuccess("Your score", subTitle: "\(score) points")
            showCongratulationsAnim(superView: alertView.view)
>>>>>>> 16988760ae68f9ad50819178b85c8bb975ffbbff
            break
        case ItemLabel.rate.rawValue:
            rateApp(appId: AppID){ success in
                debugPrint("RateApp \(success)")
            }
            break
        case ItemLabel.fbShare.rawValue:
            //Todo: Share on fb
            
            let url = URL(string: AppURL)
            let content = LinkShareContent(url: url!)
            let shareDialog = ShareDialog(content: content)
            shareDialog.mode = .native
            shareDialog.failsOnInvalidData = true
            shareDialog.completion = { result in
                // Handle share results
            }
            
            do {
                _ = try shareDialog.show()
            } catch {
                print(error.localizedDescription)
            }
            break
        case ItemLabel.appVersion.rawValue:
            let appversionAlert = SCLAlertView()
            appversionAlert.showInfo("Voca Quiz", subTitle: "Version 1.4")
            break
        default:
            fatalError("Not correct settings item")
        }
    }
    
    func showCongratulationsAnim(superView: UIView) {
        let hScreen = UIScreen.main.bounds.height
        
        let waterDropView = WaterDropsView {
            $0.dropNum = 100
            $0.maxDuration = 1
            $0.minDuration = 1
            $0.maxLength = hScreen
            $0.startAnimation()
        }
        
        superView.addSubview(waterDropView)
        waterDropView.bindFrameToSuperviewBounds()
    }
<<<<<<< HEAD
=======
}

extension SettingsViewController:  GKGameCenterControllerDelegate {
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
        kAppDelegate.bannerAdView.isTabbarShow = true
        kAppDelegate.bannerAdView.updateBannerFrame(pos: .HaveTabbar)
    }
    
    // MARK: - OPEN GAME CENTER LEADERBOARD
    func checkGCLeaderboard() {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = Leaderboad_Id
        present(gcVC, animated: true, completion: nil)
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        debugPrint(error!)
                    } else {
                        self.isAuthenticateLocal = true
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                        self.checkGCLeaderboard()
                    }
                    
                })
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                debugPrint("Local player could not be authenticated!")
                debugPrint(error!)
            }
        }
    }
>>>>>>> 16988760ae68f9ad50819178b85c8bb975ffbbff
}

extension SettingsViewController:  GKGameCenterControllerDelegate {
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
        kAppDelegate.bannerAdView.isTabbarShow = true
        kAppDelegate.bannerAdView.updateBannerFrame(pos: .HaveTabbar)
    }
    
    func checkGCLeaderboard() {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = Leaderboad_Id
        present(gcVC, animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            LoadingLaunchView.shared.hideOverlayView()
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
                self.isAuthenticateLocal = true
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        debugPrint(error!)
                    } else {
                        if self.isAuthenticateLocal == false {
                            self.isAuthenticateLocal = true
                            self.gcDefaultLeaderBoard = leaderboardIdentifer!
                            self.checkGCLeaderboard()
                            self.addScoreAndSubmitToGC(score: score)
                        }
                    }
                    
                })
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
            }
        }
    }
    
    func addScoreAndSubmitToGC(score: Int) {
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: Leaderboad_Id)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
}
