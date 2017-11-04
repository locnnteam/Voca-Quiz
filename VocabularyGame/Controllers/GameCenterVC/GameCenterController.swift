//
//  GameCenter.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 11/4/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import GameKit

class GameCenterController: ViewController, GKGameCenterControllerDelegate {
 
    @IBOutlet weak var scoreLabel: UILabel!
    
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        kAppDelegate.bannerAdView.updateBannerFrame(pos: .NoTabbar)
        
        self.authenticateLocalPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.bannerAdView.isTabbarShow = false
        LoadingLaunchView.shared.showOverlay(view: self.view)
        //Your score
        let defaults = UserDefaults.standard
        let score = defaults.integer(forKey: ScoreData)
        self.scoreLabel.text = "Your score: \(score)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
 
    // MARK: - ADD 10 POINTS TO THE SCORE AND SUBMIT THE UPDATED SCORE TO GAME CENTER
    func addScoreAndSubmitToGC(_ sender: AnyObject) {
        // Add 10 points to current score
        score += 10
        
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

    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    // MARK: - OPEN GAME CENTER LEADERBOARD
    func checkGCLeaderboard() {
        LoadingLaunchView.shared.hideOverlayView()
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = Leaderboad_Id
        present(gcVC, animated: true, completion: nil)
    }
}
