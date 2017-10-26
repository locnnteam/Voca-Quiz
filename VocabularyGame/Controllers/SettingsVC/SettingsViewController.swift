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

class SettingsViewController: UIViewController {
    enum ItemLabel: String {
        case rate = "Rate us!"
        case fbShare = "Share on Facebook"
        case appVersion = "App version"
    }
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
        
        loadSettingsItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSettingsItem() {
        //Todo: Section social
        var items: [SettingsItem] = []
        guard let rateUs = SettingsItem(label: ItemLabel.rate.rawValue, photo: nil) else {
            fatalError("Unable to instantiate rateUs")
        }
        
        guard let shareFB = SettingsItem(label: ItemLabel.fbShare.rawValue, photo: nil) else {
            fatalError("Unable to instantiate shareFB")
        }
        
        items += [rateUs, shareFB]
        self.sections.updateValue(items, forKey: 0)
        
        //Todo: Section appversion
        items.removeAll()
        guard let appVersion = SettingsItem(label: ItemLabel.appVersion.rawValue, photo: nil) else {
            fatalError("Unable to instantiate appversion")
        }
        items += [appVersion]
        self.sections.updateValue(items, forKey: 1)
        
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
            appversionAlert.showInfo("Voca Quiz", subTitle: "version 1.3")
            break
        default:
            fatalError("Not correct settings item")
        }
    }
}

