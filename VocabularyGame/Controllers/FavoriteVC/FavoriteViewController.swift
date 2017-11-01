//
//  FavoriteViewController.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 9/29/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    let identifier = "FavoritesTableViewCell"
    var lessons: [LessonItem] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lessons = CoreDataOperations().fetchData()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource, FavoritesTableViewCellDelgate{
    func favoriteDictRemove(lessonItem: LessonItem) {
        CoreDataOperations().deleteRecords(lessonItem: lessonItem)
        var index = 0
        for lesson in self.lessons {
            if lesson.name == lessonItem.name {
                break
            }
            index += 1
        }

        self.lessons.remove(at: index)
        tableView.deleteRows(at: [NSIndexPath(item: index, section: 0) as IndexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lessons.count > 0 {
            self.labelView.isHidden = true
        } else {
            self.labelView.isHidden = false
        }
        return lessons.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height - 160.0
        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FavoritesTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? FavoritesTableViewCell
        }
        
        let lessonItem = lessons[indexPath.row]
        cell?.initDataFavoriteCell(lessonItem: lessonItem)
        cell?.delegate = self
        cell?.selectionStyle = .none
        cell?.backgroundColor = BackgroundColor.HomeBackground
        return cell!
    }
}
