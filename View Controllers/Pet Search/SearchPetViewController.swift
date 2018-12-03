//
//  SearchPetViewController.swift
//  MansBestApp
//
//  Created by Conner Joseph Caprio on 11/12/18.
//  Copyright © 2018 Conner Caprio. All rights reserved.
//

import UIKit
import CoreLocation

class SearchPetViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var placeMarks = [CLPlacemark]()
    
    let dogBreeds = ["American Bulldog", "Australian Shepherd", "Basset Hound", "Beagle", "Black Labrador Retriever", "Bloodhound", "Border Collie", "Border Terrier", "Boston Terrier", "Boxer", "Chihuahua", "Chocolate Labrador Retriever", "Cockapoo", "Cocker Spaniel", "Collie", "Corgi", "Dachshund", "Dalmatian", "English Bulldog", "Flat-Coated Retriever", "Foxhound", "German Shepherd Dog", "Golden Retriever", "Great Dane", "Greyhound", "Hound", "Husky", "Labrador Retriever", "Maltese", "Mixed Breed", "Mountain Dog", "Newfoundland Dog", "Pit Bull Terrier", "Poodle", "Pug", "Retriever", "Rottweiler", "Schnauzer", "Shepherd", "Terrier", "Yellow Labrador Retriever"]
    
    let catBreeds = ["Tabby", "Australian Shepherd", "test2", "Beagle", "test3", "Bloodhound", "test4", "Border Terrier"]
    
    var pickerArray = ["error"]
    
    let numberOfRowToShow = 7
    
    @IBOutlet var animalTypeSegmented: UISegmentedControl!
    @IBOutlet var breedsPickerView: UIPickerView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageSegmented: UISegmentedControl!
    @IBOutlet var sexSegmented: UISegmentedControl!
    @IBOutlet var sizeSegmented: UISegmentedControl!
    @IBOutlet var searchButton: UIButton!
    
    var ageString = ""
    var sexString = ""
    var sizeString = ""
    var petBreedString = ""
    var petNameString = ""
    var petTypeString = "dog"
    
    
    // companyDataToPass is the data object to pass to the downstream view controller
    var searchDataToPass: NSMutableDictionary = NSMutableDictionary()
    
    // This method is invoked when the Get Quote button is tapped
    //@IBAction func searchButtonTapped(_ sender: UIButton)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeMarks = applicationDelegate.placeMarks
        pickerArray = dogBreeds
        
        breedsPickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
        
        ageSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
        sexSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
        sizeSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
        
        // Do any additional setup after loading the view.
    }
    
    /*
     -------------------------
     MARK: - Map Type Selected
     -------------------------
     */
    @IBAction func ageTypeSelected(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
            
        case 0:   // Standard map type selected
            ageString = "Baby"
            
        case 1:   // Satellite map type selected
            ageString = "Young"
            
        case 2:   // Hybrid map type selected
            ageString = "Adult"
            
        case 3:   // Hybrid map type selected
            ageString = "Senior"
            
        default:
            return
        }
    }
    
    /*
     -------------------------
     MARK: - Map Type Selected
     -------------------------
     */
    @IBAction func sexTypeSelected(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
            
        case 0:   // Standard map type selected
            sexString = "M"
            
        case 1:   // Satellite map type selected
            sexString = "F"
            
        default:
            return
        }
    }
    
    /*
     -------------------------
     MARK: - Map Type Selected
     -------------------------
     */
    @IBAction func sizeTypeSelected(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
            
        case 0:   // Standard map type selected
            sizeString = "S"
            
        case 1:   // Satellite map type selected
            sizeString = "M"
            
        case 2:   // Hybrid map type selected
            sizeString = "L"
            
        case 3:   // Hybrid map type selected
            sizeString = "XL"
            
        default:
            return
        }
    }
    
    @IBAction func animalTypeSelected(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
            
        case 0:   // Standard map type selected
            petTypeString = "dog"
            pickerArray = dogBreeds
            breedsPickerView.reloadComponent(0)
            
        case 1:   // Satellite map type selected
            petTypeString = "cat"
            pickerArray = catBreeds
            breedsPickerView.reloadComponent(0)
            
        case 2:   // Hybrid map type selected
            petTypeString = "bird"
            
        default:
            return
        }
    }
    
    /*
     ----------------------------------------
     MARK: - UIPickerView Data Source Methods
     ----------------------------------------
     */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerArray.count
    }
    
    /*
     ------------------------------------
     MARK: - UIPickerView Delegate Method
     ------------------------------------
     */
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        petBreedString = pickerArray[row]
    }
    
    /*
     ------------------------
     MARK: - IBAction Methods
     ------------------------
     */
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        // When the Text Field resigns as first responder, the keyboard is automatically removed.
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTouch(_ sender: UIControl) {
        /*
         "This method looks at the current view and its subview hierarchy for the text field that is
         currently the first responder. If it finds one, it asks that text field to resign as first responder.
         If the force parameter is set to true, the text field is never even asked; it is forced to resign." [Apple]
         
         When the Text Field resigns as first responder, the keyboard is automatically removed.
         */
        view.endEditing(true)
    }

    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        /***Perform Checks ****/
        if !applicationDelegate.userAuthorizedLocationMonitoring {
            showAlertMessage(messageHeader: "Location Services Disabled!", messageBody: "Turn Location Services On in your device settings to be able to use location services!")
            return
        }
        performSegue(withIdentifier: "Searched Pet", sender: self)
    }
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Searched Pet" {
            
            petNameString = nameTextField.text!
            
            searchDataToPass.setObject(petTypeString, forKey: "PetType" as NSCopying)
            searchDataToPass.setObject(petBreedString, forKey: "Breed" as? NSCopying ?? "" as NSCopying)
            searchDataToPass.setObject(petNameString, forKey: "Name" as? NSCopying ?? "" as NSCopying)
            searchDataToPass.setObject(ageString, forKey: "Age" as? NSCopying ?? "" as NSCopying)
            searchDataToPass.setObject(sexString, forKey: "Sex" as? NSCopying ?? "" as NSCopying)
            searchDataToPass.setObject(sizeString, forKey: "Size" as? NSCopying ?? "" as NSCopying)
            
            
            
            // Obtain the object reference of the destination view controller
            let resultsViewController: ResultsViewController = segue.destination as! ResultsViewController
            
            // Pass the data object to the downstream view controller object
            resultsViewController.petInfo = searchDataToPass
        }
    }
    
}
