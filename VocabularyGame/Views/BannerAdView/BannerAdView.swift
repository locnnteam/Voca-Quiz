//
//  BannerAdView.swift
//  VKMex
//
//  Created by Vinh Nguyen on 7/27/17.
//  Copyright © 2017 Vinh Nguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BannerAdView: UIView, GADBannerViewDelegate {
    var isTabbarShow = true
    
    enum BannerPosType: Int {
        case HaveTabbar
        case NoTabbar
        case NoAds
    }
    
    @IBOutlet var btnClose: UIButton!
    
    var bannerView: GADBannerView!
    var reloadAttemp: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        
        self.updateBannerFrame(pos: .HaveTabbar)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BannerAdView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
        self.backgroundColor = UIColor.clear
    }
    
    func loadBannerAd(bannerAdSize: GADAdSize) {
        self.bannerView = GADBannerView(adSize: bannerAdSize)
        self.bannerView.adUnitID = "ca-app-pub-7818146390468896/4055878555" // CMSConfigConstants.admob.bannerID
        self.bannerView.rootViewController = kAppDelegate.window?.rootViewController
        self.bannerView.delegate = self
        self.addSubview(self.bannerView)
        self.requestBanner()
    }
    
    func requestBanner() {
        self.bannerView.load(GADRequest())
    }
    
    // Banner Ad Delegate
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        //Check Tabbar enable or not
        if isTabbarShow {
            self.updateBannerFrame(pos: .HaveTabbar)
        } else {
            self.updateBannerFrame(pos: .NoTabbar)
        }
        kAppDelegate.window?.bringSubview(toFront: kAppDelegate.bannerAdView)
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        debugPrint("Loaded fail banner Ad = ", error.debugDescription)
        self.updateBannerFrame(pos: .NoAds)
    }
    
    func updateBannerFrame(pos: BannerPosType){
        
        let tabBarHeight = kAppDelegate.tabbarController.tabBar.frame.size.height
        var posY:CGFloat = UIScreen.main.bounds.height
        var bannerHeight: CGFloat = 0
        let bannerWidth = UIScreen.main.bounds.width

        switch pos {
        case .HaveTabbar:
            bannerHeight = FontSizeCustom.getHeightOfBanner()
            posY = posY - tabBarHeight - bannerHeight
            
        case .NoTabbar:
            bannerHeight = FontSizeCustom.getHeightOfBanner()
            if #available(iOS 11.0, *) {
                let bottomSafeInsets = self.superview?.safeAreaInsets.bottom
                posY = posY - bottomSafeInsets!
            }
            posY = posY - bannerHeight
        case .NoAds:
            bannerHeight = 0
            if #available(iOS 11.0, *) {
                let bottomSafeInsets = self.superview?.safeAreaInsets.bottom
                posY = posY - bottomSafeInsets!
            }
            posY = posY - bannerHeight
        }
        
        self.frame = CGRect(x: 0, y: posY, width: bannerWidth, height: bannerHeight)
    }
    
    func setShowHideCloseAd(isShow: Bool){
        self.btnClose.isHidden = !isShow
    }
    
    @IBAction func btnClose_Clicked(sender: UIButton){
        debugPrint("btnClose_Clicked")
        self.updateBannerFrame(pos: .NoAds)
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
