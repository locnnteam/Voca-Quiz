//
//  RatingControlAnim.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/21/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import FaveButton

@IBDesignable class RatingControlAnim: UIStackView {
    //MARK: Properties
    var ratingButtons: [FaveButton] = []
    var isIgnoreTapped:Bool = false
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    func startAnim() {
        updateButtonSelectionStates()
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
    
    func ratingButtonTapped(button: FaveButton) {
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
    
    func setupButtons() {
        
        // Clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let filledStar = #imageLiteral(resourceName: "filledStar")
        let emptyStar = #imageLiteral(resourceName: "emptyStar")
        
        for index in 0..<starCount {
            // Create the button
            let button = FaveButton(
                frame: CGRect(x:0, y:0, width: wStar + 5, height: hStar + 5),
                faveIconNormal: #imageLiteral(resourceName: "filledStar")
            )
            button.normalColor = BackgroundColor.NavigationBackgound
            button.selectedColor = .green
            //faveButton.delegate = self

            // Set the button images
            button.setImage(emptyStar, for: .selected)
            button.setImage(filledStar, for: .normal)
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
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
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

