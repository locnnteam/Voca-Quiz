//
//  LoadingLaunchView.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 8/14/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

public class LoadingLaunchView{
    var viewBg: UIView!
    var overlayView: NVActivityIndicatorView!
    
    class var shared: LoadingLaunchView {
        struct Static {
            static let instance: LoadingLaunchView = LoadingLaunchView()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView!) {
        self.viewBg = UIView(frame: UIScreen.main.bounds)
        self.viewBg.backgroundColor = BackgroundColor.LoadingLaunchBkg
        view.addSubview(self.viewBg)
        
        overlayView = NVActivityIndicatorView(frame: UIScreen.main.bounds, type: .lineScalePulseOut, color: .white, padding: 0)
        let w = FontSizeCustom.getActivityIndicator()
        overlayView.frame.size = CGSize(width: w, height: w)
        overlayView.center =  CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2 - 64.0)
        
        overlayView.backgroundColor = .clear
        view.addSubview(overlayView)
        overlayView.startAnimating()
    }
    
    public func hideOverlayView() {
        overlayView.stopAnimating()
        overlayView.removeFromSuperview()
        self.viewBg.removeFromSuperview()
    }
}

