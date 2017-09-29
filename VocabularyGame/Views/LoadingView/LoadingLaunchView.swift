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
        title.font = UIFont(name: "OpenSans", size: FontSizeCustom.getFontSize())
        title.textAlignment = .center
        title.sizeToFit()
        title.textColor = .white
        title.center = CGPoint(x: overlayView.frame.size.width/2, y: overlayView.frame.height/2 - 64.0)
        overlayView.addSubview(title)
        
        overlayView.backgroundColor = BackgroundColor.NavigationBackgound
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        overlayView.removeFromSuperview()
    }
}

