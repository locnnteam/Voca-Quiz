//
//  ContentViewCell.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/17/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

class HomeContentViewCell: UICollectionViewCell {
    @IBOutlet weak var lessonLevelLabel: UILabel!
    @IBOutlet weak var ratingControll: RatingControl!
    @IBOutlet weak var lockView: UIImageView!
    @IBOutlet weak var lessonImage: UIImageView!
    @IBOutlet weak var editIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initViewCell()
    }

    func initViewCell(){
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.lessonLevelLabel.backgroundColor = .white
        self.lessonLevelLabel.font = self.lessonLevelLabel.font.withSize(FontSizeCustom.getFontSize())
        
        lockView.isHidden = true
        editIcon.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.lessonImage.roundCorners([.bottomLeft, .bottomRight], radius: 5.0)
            self.lessonImage.layer.masksToBounds = true
        }
        self.layoutIfNeeded()
    }
    
    func changeLabelStyle(isEdit: Bool){
        self.editIcon.isHidden = !isEdit
    }
}
