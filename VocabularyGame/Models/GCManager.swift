//
//  GCManager.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 11/5/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import GameKit

class GCManager {
    // MARK: - ADD 10 POINTS TO THE SCORE AND SUBMIT THE UPDATED SCORE TO GAME CENTER
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
