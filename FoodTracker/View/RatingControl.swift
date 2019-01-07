//
//  RatingControl.swift
//  FoodTracker
//
//  Created by daicudu on 12/7/18.
//  Copyright © 2018 daicudu. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
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
        super.init(frame : frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder : coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons) ")
        }
    
        // caculate the rating of the selected button
        let selectedRating = index+1
        
        if selectedRating == rating {
            // if the selected star represents the current rating. reset the rating to 0.
            rating = 0
        }else{
            // otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    //MARK: Private Methods
    private func setupButtons() {
        //Clear any buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        for index in 0..<starCount {
            // Load buttion images
            let bundle = Bundle(for: type(of: self))
            let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
            let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
            let hightlightedStar = UIImage(named: "hightlightedStar", in: bundle, compatibleWith: self.traitCollection)
            
            // create the Button
            let button = UIButton()
            
            //set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(hightlightedStar, for: .highlighted)
            button.setImage(hightlightedStar, for: [.highlighted, .selected])
            
            //add Contrants
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //set the accsessibility label
            button.accessibilityLabel = "set \(index + 1) star ratring"
            
            //Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            //ADD the new button to the rating button array
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            let hintString: String?
            if rating == index + 1 {
                hintString = " tap to reset the ratring to zero"
            }else{
                hintString = nil
            }
            
            // caculate the value string
            let valueString: String
            switch (rating)  {
            case 0:
                valueString = " no rating set "
            case 1:
                valueString = "1 star set"
            default:
                valueString = " \(rating) stars set"
            }
            
            //Asign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    
    
}