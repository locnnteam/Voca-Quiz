//
//  LoadingLaunchView.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 8/14/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit
public class LoadingLaunchView{
    
    var overlayView = UIView()
    
    class var shared: LoadingLaunchView {
        struct Static {
            static let instance: LoadingLaunchView = LoadingLaunchView()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView!) {
        overlayView = UIView(frame: UIScreen.main.bounds)
        
        let title = UILabel()
        title.text = "Vocabulary Game Start"
        title.font = title.font.withSize(FontSizeCustom.getFontSize())
        title.textAlignment = .center
        title.sizeToFit()
        title.textColor = .white
        title.center = overlayView.center
        overlayView.addSubview(title)
        
        overlayView.backgroundColor = BackgroundColor.LoadingLaunchBkg
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        overlayView.removeFromSuperview()
    }
}

