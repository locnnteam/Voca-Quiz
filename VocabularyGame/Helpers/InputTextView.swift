//
//  InputTextView.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 8/4/17.
//  Copyright © 2017 bktech. All rights reserved.
//


import UIKit

protocol InputTextDelegate {
    func inputTextCorrect(isCorrect: Bool)
    func helpButtonTapped()
    func showIconPass(isShow: Bool)
    func replayAudio()
}

@IBDesignable class InputTextView: UIStackView, KeyPressDelegate {
    
    //MARK: Properties
    var wordKey: String?
    var countButtons = 1
    private var textButtons = [UITextField]()
    private var currentIndex =  0
    
    //init string of keyboard
    var strKeyboard: String {
        var str = ""
        for text in textButtons {
            str += text.text!
        }
        return str
    }
    
    var delegate: InputTextDelegate?
    
    
    @IBInspectable var starSize: CGSize = CGSize(width: 30.0, height: 30.0) {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Private Methods
    func setupButtons() {
        // Clear any existing buttons
        for button in textButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        textButtons.removeAll()
        
        // initialize custom keyboard
        var keyboardView = KeyboardView()
        keyboardView = Bundle.main.loadNibNamed("KeyboardView", owner: self, options: nil)?[0] as! KeyboardView
        keyboardView.delegate = self
        
        guard let key = wordKey else {
            fatalError("InputTextView: Key check is nil")
        }

        keyboardView.setup(word: key, random: 3)
        let strings: [Character] = Array(key.characters)
        countButtons = strings.count
        
        //resize if need
        var size = starSize.width
        let minWidth = CGFloat(countButtons) * (size + 10.0) + 8
        let viewWidth = UIScreen.main.bounds.width
        
        if viewWidth < minWidth {
            size = (viewWidth - 8)/CGFloat(countButtons) - 5.0
        }
        
        for _ in 0..<countButtons {
            // Create the button
            let button = UITextField()
            button.inputView = keyboardView
            // Set the button images
            button.font = UIFont(name: "Helvetica-Bold", size: FontSizeCustom.getLabelFontSize())
            button.textColor = BackgroundColor.LessonLabelBackground
            button.tintColor = BackgroundColor.LessonLabelBackground
            //button.insertText(String(strings[index]))
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: size).isActive = true
            button.widthAnchor.constraint(equalToConstant: size).isActive = true
            button.textAlignment = .center
            button.setBottomBorder()
            addArrangedSubview(button)
            textButtons.append(button)
        }
        
        becomeEdditing(index: 0)
        
        //Suggestion character
        if (countButtons - 5) > 0 {
           suggestCharacters(words: key, num: countButtons - 5)
        }
    }
    
    private func updateKeybox(index: Int?, ch: String?) {
        if ch == "" {
            if textButtons[index!].text == "" {
                if index! > 0 {
                    becomeEdditing(index: index! - 1)
                } else {
                    becomeEdditing(index: index!)
                }
            } else {
                textButtons[index!].text = ""
                becomeEdditing(index: index!)
            }
            
        } else {
            if textButtons[index!].text == ""{
                textButtons[index!].insertText(ch!)
                if (index! < countButtons - 1){
                    for index in index!..<self.countButtons {
                        if textButtons[index].text == "" {
                            becomeEdditing(index: index)
                            break
                        }
                    }
                }
                
                let result = strKeyboard
                if result == wordKey {
                    debugPrint("Test case is pass")
                    self.delegate?.inputTextCorrect(isCorrect: true)
                }else if result.characters.count == wordKey?.characters.count{
                    debugPrint("Test case is fail")
                    self.delegate?.inputTextCorrect(isCorrect: false)
                }
            }
        }
    }
    
    private func becomeEdditing(index: Int){
        textButtons[index].becomeFirstResponder()
        currentIndex = index
    }
    
    private func suggestCharacters(words: String, num: Int){
        let strings: [Character] = Array(words.characters)
        
        var nums = [Int]()
        
        for index in 0..<(strings.count){
            nums.append(index)
        }
        
        for _ in 0..<num{
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(nums.count)))
            
            // your random number
            let randNum = nums[arrayKey]
            
            let index = words.index (words.startIndex, offsetBy: randNum)
            textButtons[randNum].placeholder = String(words[index])
            
            // make sure the number isnt repeated
            nums.remove(at: arrayKey)
        }
    }
    
    //MARK: KeyboardViewDelegate
    
    func backSpacePressed() {
        self.delegate?.showIconPass(isShow: false)
        for index in 0..<self.textButtons.count {
            if textButtons[index].isFirstResponder {
                updateKeybox(index: index, ch: "")
            }
        }
    }
    
    func returnPressed() {
        //Todo return after finished keyboard
        for button in textButtons {
            if button.isFirstResponder {
                button.resignFirstResponder()
                button.endEditing(true)
                break
            }
        }
    }
    
    func playAudioPressed() {
        self.delegate?.replayAudio()
    }
    
    func helpPressed() {
        var cursor: Int!
        for index in 0..<self.textButtons.count {
            if textButtons[index].isFirstResponder {
                cursor = index
                break
            }
        }
        
        let index = wordKey!.index(wordKey!.startIndex, offsetBy: cursor)
        buttonTapped(str: String(wordKey![index]))
        self.delegate?.helpButtonTapped()
    }
    
    func buttonTapped(str: String) {
         for index in 0..<self.textButtons.count {
            if textButtons[index].isFirstResponder {
                updateKeybox(index: index, ch: str)
                break
            }
        }
    }
}

