//
//  backView.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/3/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

protocol BackViewDelegate {
    func audioDictPlay()
    func favoriteDictAdd()
}

class BackView: UIView {
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var wordLabel: UILabel!
    var delegate: BackViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let height = 0
        self.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: height)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BackView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    @IBAction func favoritesButtonTapped(_ sender: Any) {
        self.delegate.favoriteDictAdd()
    }
    
    @IBAction func audioButtonTapped(_ sender: Any) {
        self.delegate.audioDictPlay()
    }
}
