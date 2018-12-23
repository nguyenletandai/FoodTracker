//
//  ViewController.swift
//  FoodTracker
//
//  Created by daicudu on 12/5/18.
//  Copyright © 2018 daicudu. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentaion), this view controller need to be dismiss  in to different way
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else{
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    
    }
    
    
    /*
    This value is either passed by `MealViewcontroller` in
    `prepare(for:sender:)`
    or contructed as part of adding a new meal
    */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle the text field's user input through delegate callbacks
        mealTextField.delegate = self
        
        // Set up view if editing an exiting meal
        if let meal = meal {
            navigationItem.title = meal.name
            mealTextField.text = meal.name
            mealImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        //Enable the save button only if the text field had a valid Meal name
        updateSaveButtonState()
        
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the save button while editing
            saveButton.isEnabled = false
    }
    
    @IBAction func selectImageFromLibary(_ sender: UITapGestureRecognizer) {
        //hide the keyboard
        mealTextField.resignFirstResponder()
        
        //UIImagePickerController is a view controller that lets a user pick media from their photo libary.
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType =  .photoLibrary
        
        // Make sure ViewController is notified when user picks an imageview
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        mealImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    // This method lets you configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only whene save button is pressed
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("the save button was not pressed, cacelling", log: OSLog.default, type: .debug)
            return
        }
        
        if meal != nil {
            meal?.name =  mealTextField.text ?? ""
            meal?.photo = mealImageView.image
            meal?.rating = ratingControl.rating
        } else {
            let name = mealTextField.text ?? ""
            let photo = mealImageView.image
            let rating = ratingControl.rating
            // Set the meal to be pressed to mealViewcontroller affer the unwind segue.
            meal = Meal(name: name, photo: photo, rating: rating)
        }
       
    }
    
    
    
    
    
    //MARK: Private methods
    private func    updateSaveButtonState() {
        //Disable the save button if the text field is empty
        let text = mealTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

