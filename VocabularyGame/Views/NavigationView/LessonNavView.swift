//
//  LessonNavView.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/19/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import M13ProgressSuite

protocol LessonViewCellDelegate {
    
    func backToHome(alertType: AlertPopupType, showPopup: Bool)
    func pauseLessonTest()
}

class LessonNavView: UIView, CountdownLabelDelegate {

    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var ratingControl: RatingControlAnim!
    @IBOutlet weak var countDownLabel: CountdownLabel!
    @IBOutlet weak var progressBar: M13ProgressViewBorderedBar!

    var timeToFinished: Double!
    var delegate: LessonViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let height = 64
        self.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: height)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LessonNavView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func setup(){
        homeButton.layer.cornerRadius = 0.5 * homeButton.bounds.size.width
        homeButton.clipsToBounds = true
        
        self.ratingControl.setupButtons()
        self.ratingControl.rating = 5
        
        countDownLabel.textColor = .white
        countDownLabel.baselineAdjustment = .alignCenters
        countDownLabel.textAlignment = .center
        countDownLabel.timeFormat = "mm:ss"
        countDownLabel.animationType = .Evaporate
        countDownLabel.countdownDelegate = self
        
        progressBar.cornerType = .init(1)
        progressBar.cornerRadius = 6.0
        progressBar.primaryColor = .white
        progressBar.secondaryColor = .white
        progressBar.setProgress(0.0, animated: true)
    }
    
    func setTimeToFinished(duration: Double){
        countDownLabel.cancel()
        countDownLabel.setCountDownTime(minutes: duration)
        countDownLabel.start()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        delegate?.backToHome(alertType: .None, showPopup: false)
    }
    
    func countdownFinished() {
        delegate?.backToHome(alertType: .TimeLimit, showPopup: true)
    }
}
