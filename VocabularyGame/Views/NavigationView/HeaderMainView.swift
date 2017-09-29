//
//  HeaderMainView.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 8/7/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

protocol HeaderMainViewDelegate {
    func selectedMenuItem(index: Int)
}

class HeaderMainView: UIView {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var delegate: HeaderMainViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let height = 44
        self.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: height)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HeaderMainView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        let font = UIFont(name: "OpenSans-Bold", size: FontSizeCustom.getFontSize())
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
    }

    @IBAction func indexChanged(_ sender: Any) {
        delegate?.selectedMenuItem(index: segmentedControl.selectedSegmentIndex)
    }
}
