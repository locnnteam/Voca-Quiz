//
//  LoadingOverlay.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 7/4/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit
import M13ProgressSuite

public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView!) {
        overlayView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayView.backgroundColor = UIColor.white
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.color = BackgroundColor.NavigationBackgound
        activityIndicator.center = CGPoint(x: overlayView.frame.size.width/2, y: overlayView.frame.height/2 - 64.0)
        activityIndicator.hidesWhenStopped = true
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
