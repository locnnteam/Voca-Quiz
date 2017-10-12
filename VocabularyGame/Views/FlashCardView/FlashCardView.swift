//
//  FlashCardView.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 9/28/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

protocol FlashCardViewDelegate {
    func audioDictPlay()
    func favoriteDictAdd()
}

class FlashCardView: UIView {

    @IBOutlet weak var defination: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    var delegate: FlashCardViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let height = UIScreen.main.bounds.height - 64
        let width = UIScreen.main.bounds.width
        self.frame = CGRect(x: 0, y: 64, width: width, height: height)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FlashCardView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 
        self.favoriteButton.setBackgroundColor(color: BackgroundColor.FlashCardBackground, forState: .selected)
        self.favoriteButton.setBackgroundColor(color: BackgroundColor.FlashCardBackground, forState: .normal)
        
        self.addSubview(view)
    }

    @IBAction func audioButtonTapped(_ sender: Any) {
        self.delegate.audioDictPlay()
    }
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        self.delegate.favoriteDictAdd()
    }
}
