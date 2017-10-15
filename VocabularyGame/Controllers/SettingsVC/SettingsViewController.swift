//
//  SettingsViewController.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/25/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    enum ItemLabel: String {
        case rate = "Rate us!"
        case fbShare = "Share on Facebook"
    }
    let AppID = "id1278800758"
    
    var settings: [SettingsItem] = []
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        loadSettingsItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSettingsItem() {
        
        guard let rateUs = SettingsItem(label: ItemLabel.rate.rawValue, photo: nil) else {
            fatalError("Unable to instantiate rateUs")
        }
        
        guard let shareFB = SettingsItem(label: ItemLabel.fbShare.rawValue, photo: nil) else {
            fatalError("Unable to instantiate shareFB")
        }
        
        self.settings += [rateUs, shareFB]
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
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
        let item = self.settings[indexPath.row]
        
        cell?.label.text = item.label
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let label = settings[indexPath.row].label
        switch label {
        case ItemLabel.rate.rawValue:
            rateApp(appId: AppID){ success in
                debugPrint("RateApp \(success)")
            }
            break
        case ItemLabel.fbShare.rawValue:
        //Todo: Share on fb
            break
        default:
            fatalError("Not correct settings item")
        }
    }
}

