//
//  Config.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/30/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

enum FireBaseURL{
    static let jsonHomeDataURL = "https://firebasestorage.googleapis.com/v0/b/vocabularygame-53c28.appspot.com/o/Voca%2FVocabularyGame_V2.json?alt=media&token=6666dba1-6362-428e-894a-38add91f7dc4"//"https://firebasestorage.googleapis.com/v0/b/vocabularygame-b034c.appspot.com/o/Words%2FVocabularyGame.json?alt=media&token=426eaac9-6e28-4aa1-bffe-9638cc010cd8"
    
    static let jsonAdsIDURL = "https://firebasestorage.googleapis.com/v0/b/vocabularygame-b034c.appspot.com/o/Words%2FGGAdsID.json?alt=media&token=e5cdb797-64fd-4cc2-918b-55c51d6e6f7f"
}

let DocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

let WidthBorderLessonCell = CGFloat(1.0)

enum Sound {
    static let passSounds = Bundle.main.path(forResource: "pass", ofType: ".mp3")
    static let failSounds = Bundle.main.path(forResource: "false", ofType: ".mp3")
}

enum BackgroundColor {
    static let LoadingLaunchBkg = UIColor(red: 0, green: 175/255, blue: 240/255, alpha: 1)
    static let NavigationBackgound = UIColor(red: 1/255, green: 143/255, blue: 229/255, alpha: 1)
    static let HomeBackground = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
    static let LessonBackground = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
    static let BorderGrayColor = UIColor(red: 211/255, green: 218/255, blue: 224/255, alpha: 1)
    static let LessonLabelBackground = UIColor(red: 132/255, green: 59/255, blue: 41/255, alpha: 1)
}

class FontSizeCustom {
    static func getFontSize() -> CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            return 24.0
        case .phone:
            return 16.0
        default:
            return 24.0
        }
    }
    
    static func getLabelFontSize() -> CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            return 34.0
        case .phone:
            return 28.0
        default:
            return 34.0
        }
    }
}
