//
//  AppDelegate.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 8/10/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMobileAds
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GADInterstitialDelegate{

    var window: UIWindow?
    var nav: UINavigationController?
    var tabbarController = UITabBarController()

    var interstitialAd: GADInterstitial!
    
    lazy var homeVC: HomeViewController = {
        return HomeViewController(nibName: "HomeViewController", bundle: nil)
    }()
    
    lazy var homeTypingVC: HomeViewController = {
        return HomeViewController(nibName: "HomeViewController", bundle: nil)
    }()
    
    lazy var favoritesVC: FavoriteViewController = {
        return FavoriteViewController(nibName: "FavoriteViewController", bundle: nil)
    }()
    
    var adRootInterstitialVC: UIViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        FirebaseApp.configure()
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.initAdmobPub()
        
        //TabarView 1235
        homeVC.title = "Picture Pickup"
        homeVC.isMainView = true
        homeVC.tabBarItem = UITabBarItem(title: "Picture", image: #imageLiteral(resourceName: "picture_pickup"), selectedImage: #imageLiteral(resourceName: "picture_pickup_selected"))

        homeTypingVC.title = "Typing Quiz"
        homeTypingVC.isMainView = false
        homeTypingVC.tabBarItem = UITabBarItem(title: "Typing", image: #imageLiteral(resourceName: "typing"), selectedImage: #imageLiteral(resourceName: "typing_selected"))
        
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        let controllers = [homeVC, homeTypingVC, favoritesVC] as [Any]
        tabbarController.viewControllers = controllers as? [UIViewController]
        tabbarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0 as! UIViewController)}
        
        //nav = UINavigationController(rootViewController: self.homeVC)
        self.window?.rootViewController = self.tabbarController
        
        // Changing the navigation controller's background colour
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans", size: 10)!], for: .normal)
        
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = BackgroundColor.NavigationBackgound
        // Changing the navigation controller's title colour
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        // Changing the colour of the bar button items
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes =  [NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: FontSizeCustom.getFontSize())!]
        
        // Changing the tint colour of the tab bar icons
        UITabBar.appearance().tintColor = UIColor(red: 2.0/255, green: 166.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundColor = BackgroundColor.HomeBackground
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "VocabularyGame")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Admob View
    
    func initAdmobPub(){
        GADMobileAds.configure(withApplicationID: "pub-7818146390468896")
        self.requestInterstitialAd()
    }
    
    func requestInterstitialAd(){
        var adID = "ca-app-pub-7818146390468896/9219733068"
        Alamofire.request(FireBaseURL.jsonAdsIDURL).responseJSON { response in
            if (response.error == nil) {
                if let data = response.data{
                    let json = JSON(data: data)
                    guard let id = json[0]["adsID"].string else{
                        debugPrint("adID is nil")
                        return
                    }
                    
                    adID = id
                }
            }
        }
        self.interstitialAd = GADInterstitial(adUnitID: adID)
        let request = GADRequest()
        self.interstitialAd.load(request)
        self.interstitialAd.delegate = self
    }
    
    func showInterstialAd(adRootVC: UIViewController){
        if self.interstitialAd.isReady == true{
            debugPrint("interstitialAd.isReady ")
            self.adRootInterstitialVC = adRootVC
            self.interstitialAd.present(fromRootViewController: adRootVC)
            
        }else{
            debugPrint("[ERROR] interstitialAd.isReady fail")
            //self.adRootInterstitialVC
            //self.adRootInterstitialVC == LessonViewController
            self.requestInterstitialAd()
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitialAd = nil
        self.requestInterstitialAd()
        
    }
}


