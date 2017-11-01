//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/2/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

let wStar = 25
let hStar = 25

@IBDesignable class RatingControl: UIStackView {
    enum LevelStar: Int {
        case High = 0
        case Medium
        case Low
        case None
    }
    var star: Int = 5
    
    //MARK: Properties
    var ratingButtons = [UIButton]()
    var isNeedResize = false {
        didSet{
            setupButtons()
        }
    }
    
    var isIgnoreTapped:Bool = true
    
    var rating: Int {
        get {
            return self.star
        }
        
        set(newRating) {
            self.star = newRating
            var levelStar: LevelStar
            if rating > 4 {
                levelStar = .High
            } else if rating > 2 {
                levelStar = .Medium
            } else {
                levelStar = .Low
            }
            updateButtonSelectionStates(levelStar: levelStar)
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: wStar, height: hStar) {
        didSet {
            setupButtons()
        }
    }

    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    func ignoreTapped(isIgnore: Bool){
        isIgnoreTapped = isIgnore
    }
    
    //MARK: Button Action
    
    func getPositionStar(index: Int) -> CGPoint {
        return ratingButtons[index].layer.position
    }
    
    func ratingButtonTapped(button: UIButton) {
        if isIgnoreTapped == false {
            guard let index = ratingButtons.index(of: button) else {
                fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
            }
            
            // Calculate the rating of the selected button
            let selectedRating = index + 1
            
            if selectedRating == rating {
                // If the selected star represents the current rating, reset the rating to 0.
                rating = 0
            } else {
                // Otherwise set the rating to the selected star
                rating = selectedRating
            } 
        }
    }
    
    
    //MARK: Private Methods
    
    private func setupButtons() {
        
        // Clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)

        
        for index in 0..<starCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.isUserInteractionEnabled = false
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
//        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates(levelStar: LevelStar) {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            //Todo: Config color star
            switch levelStar {
            case .High:
                button.setImage(#imageLiteral(resourceName: "filledStar"), for: .selected)
                break
            case .Medium:
                button.setImage(#imageLiteral(resourceName: "yellowStar"), for: .selected)
                break
            case .Low:
                button.setImage(#imageLiteral(resourceName: "redStar"), for: .selected)
                break
            default:
                fatalError("Not correct level star")
            }
            
            button.isSelected = index < rating
            
            // Set accessibility hint and value
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }

            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
