//
//  KeyboardView.swift
//  CustomKeyboard
//
//  Created by Nguyen Nhat  Loc on 7/29/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

protocol KeyPressDelegate {
    func buttonTapped(str: String)
    func backSpacePressed()
    func returnPressed()
    func playAudioPressed()
    func helpPressed()
}

class KeyboardView: UIView {
    
    var capsLockOn = false
    
    @IBOutlet weak var row1: UIView!
    @IBOutlet weak var row2: UIView!
    @IBOutlet weak var row3: UIView!
    @IBOutlet weak var row4: UIView!
    
    var delegate: KeyPressDelegate?
    var buttons = [UIButton]()
    
    func setup(word: String?, random: Int){
        buttons.removeAll()
        guard let _word = word else {
            fatalError("word is nil")
        }
        
        for subview in self.row1.subviews {
            if let button =  subview as? UIButton{
                buttons.append(button)
                button.setEnable(isEnable: false)
                
                if _word.lowercased().contains(button.titleLabel!.text!.lowercased()) {
                    button.setEnable(isEnable: true)
                    buttons.removeLast()
                }
            }
        }
        
        for subview in self.row2.subviews {
            if let button =  subview as? UIButton{
                buttons.append(button)
                button.setEnable(isEnable: false)
                
                if _word.lowercased().contains(button.titleLabel!.text!.lowercased()) {
                    button.setEnable(isEnable: true)
                    buttons.removeLast()
                }
            }
        }
        
        for subview in self.row3.subviews {
            if let button =  subview as? UIButton{
                if !(button.titleLabel?.text == " "){
                    buttons.append(button)
                    button.setEnable(isEnable: false)
                    
                    if _word.lowercased().contains(button.titleLabel!.text!.lowercased()) {
                        button.setEnable(isEnable: true)
                        buttons.removeLast()
                    }
                }else{
                    button.setEnable(isEnable: true)
                }
            }
        }
        
        for subview in self.row4.subviews {
            if let button =  subview as? UIButton{
                button.setEnable(isEnable: true)
            }else{
                for button in subview.subviews{
                    if let button =  button as? UIButton{
                        button.setEnable(isEnable: true)
                    }
                }
            }
        }
    
        //Generate random button enable
        for _ in 1...random {
            let randomNum = Int(arc4random_uniform(UInt32(buttons.count)))
            buttons[randomNum].setEnable(isEnable: true)
            buttons.remove(at: randomNum)
        }
    }
    
    
    @IBAction func capsLockPressed(_ button: UIButton) {
        capsLockOn = !capsLockOn
        changeCaps(row1)
        changeCaps(row2)
        changeCaps(row3)
    }
    
    @IBAction func keyPressed(_ button: UIButton) {
        let string = button.titleLabel!.text
        delegate?.buttonTapped(str: string!)
    }
    
    @IBAction func backSpacePressed(_ button: UIButton) {
        delegate?.backSpacePressed()
    }
    
    @IBAction func playAudioPressed(_ button: UIButton) {
        delegate?.playAudioPressed()
    }

    @IBAction func helpPressed(_ button: UIButton) {
        delegate?.helpPressed()
    }
    
    @IBAction func returnPressed(_ button: UIButton) {
        delegate?.returnPressed()
    }
    
    func changeCaps(_ containerView: UIView) {
        for view in containerView.subviews {
            if let button = view as? UIButton {
                let buttonTitle = button.titleLabel!.text
                if capsLockOn {
                    let text = buttonTitle!.uppercased()
                    button.setTitle("\(text)", for: UIControlState())
                } else {
                    let text = buttonTitle!.lowercased()
                    button.setTitle("\(text)", for: UIControlState())
                }
            }
        }
    }
}

extension UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.lightGray : UIColor.white
        }
    }
    
    func setEnable(isEnable: Bool){
        self.isEnabled = isEnable
        if isEnable {
            self.layer.backgroundColor = UIColor.white.cgColor
            self.layer.borderColor = UIColor.gray.cgColor
            self.layer.borderWidth = 0.0
            self.layer.cornerRadius = 5
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 1.0
            
        }else{
            self.layer.backgroundColor = UIColor(red: 215/255, green: 219/255, blue: 225/255, alpha: 1.0).cgColor
            self.layer.cornerRadius = 5
        }
    }
}
