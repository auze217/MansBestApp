//
//  SearchResultsViewController.swift
//  MansBestApp
//
//  Created by Austin Connor Zensen on 11/26/18.
//  Copyright © 2018 Conner Caprio. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    @IBOutlet var scrollMenu: UIScrollView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var breedLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var sexLabel: UILabel!
    
    
    var petInfo: NSMutableDictionary = NSMutableDictionary()
    var pets = [NSMutableDictionary]()
    var selectedPet: NSMutableDictionary = NSMutableDictionary()
    var previousButton: UIButton = UIButton()
    var scrollMenuHeight = 300.0
    /*
     [0] Size
     [1] PetType
     [2] Name
     [3] Age
     [4] Sex
     [5] Breed
    */
    var apiKey = "166ad61e92ce53ba290b0da71abe7fd5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = petInfo["Size"] as! String
        let petType = petInfo["PetType"] as! String
        let name = petInfo["Name"] as! String
        let age = petInfo["Age"] as! String
        let sex = petInfo["Sex"] as! String
        let breed = petInfo["Breed"] as! String
        //petType should be the only one that is guaranteed to be something so for the rest you have to check
        //error check for pettype is handled in searchPet
        //checks
        //http://api.petfinder.com/my.method?key=12345&arg1=foo
        var apiString = "http://api.petfinder.com/pet.find?key=\(apiKey)&animal=\(petType)&location=24060"
        if !size.isEmpty {
            apiString = apiString + "&size=\(size)"
        }
        if !name.isEmpty {
            apiString = apiString + "&name=\(name)"
        }
        if !age.isEmpty {
            apiString = apiString + "&age=\(age)"
        }
        if !sex.isEmpty {
            apiString = apiString + "&sex=\(sex)"
        }
        if !breed.isEmpty {
            apiString = apiString + "&breed=\(breed)"
        }
        //get the full description of the dog and put the format as a json
        apiString = apiString + "&count=&&format=json"
        let apiUrl = URL(string: apiString)
        let jsonData: Data?
        do {
            jsonData = try Data(contentsOf: apiUrl!, options: NSData.ReadingOptions.mappedIfSafe)
        } catch {
            showAlertMessage(messageHeader: "Error Calling PetFinder API", messageBody: "Therer was an error trying to find pets that match your description!")
            return
        }
        if let jsonDataFromURL = jsonData {
            do {
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromURL, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                let petDictionary = jsonDataDictionary as! Dictionary<String, AnyObject>
                let test = petDictionary["petfinder"]!["pets"] as! Dictionary<String, AnyObject>
                pets = test["pet"] as? [NSMutableDictionary] ?? []
                if pets.isEmpty {
                    pets = [test["pet"] as! NSMutableDictionary]
                }
                setUp()
            } catch let error as NSError {
                showAlertMessage(messageHeader: "Error Accessing the PetFinder API", messageBody: "Error Details: \(error.localizedDescription)")
                return
            }
        }
        // Do any additional setup after loading the view.
    }
    //setup to display the dog images
    func setUp() {
        ///scrollMenu.backgroundColor = backgroundColorToUse
        var listOfPetButtons = [UIButton]()
        for i in 0..<pets.count {
            //make the button
            let scrollButton = UIButton(type: UIButton.ButtonType.custom)
            let pet = pets[i]
            let petMedia = pet["media"] as! NSMutableDictionary
            let petPhotosDict = petMedia["photos"] as! NSMutableDictionary
            let petPhotos = petPhotosDict["photo"] as! [NSMutableDictionary]
            let imageString = petPhotos[2]["$t"] as! String
            let imageUrl = URL(string: imageString)
            //let petImage = UIImage(named: imageString)
            var petImage :UIImage
            let imageData: Data?
            do {
                imageData = try Data(contentsOf: imageUrl!)
                petImage = UIImage(data: imageData!)!
                scrollButton.frame = CGRect(x: 0.0, y: 0.0, width: 315.0, height: scrollMenuHeight)
                scrollButton.setImage(petImage, for: UIControl.State())
                scrollButton.addTarget(self, action: #selector(SearchResultsViewController.buttonPressed(_:)), for: .touchUpInside)
                scrollButton.tag = i
                listOfPetButtons.append(scrollButton)
            } catch {
                //image unavailable
                petImage = UIImage(named: "ben.jpg")!
                scrollButton.frame = CGRect(x: 0.0, y: 0.0, width: Double(petImage.size.width + 40.0), height: scrollMenuHeight)
                scrollButton.setImage(petImage, for: UIControl.State())
                scrollButton.addTarget(self, action: #selector(SearchResultsViewController.buttonPressed(_:)), for: .touchUpInside)
                scrollButton.tag = i
                listOfPetButtons.append(scrollButton)
            }
            //let petImage = UIImage(data: imageData)
            
        }
        var sumOfWidths: CGFloat = 0.0
        for i in 0..<listOfPetButtons.count {
            let button: UIButton = listOfPetButtons[i]
            
            var buttonRect: CGRect = button.frame
            buttonRect.origin.x = sumOfWidths
            button.frame = buttonRect
            scrollMenu.addSubview(button)
            sumOfWidths += button.frame.size.width
        }
        scrollMenu.contentSize = CGSize(width: sumOfWidths, height: CGFloat(scrollMenuHeight))
        
        //hiding left button
        leftButton.isHidden = true
        let defaultButton: UIButton = listOfPetButtons[0]
        defaultButton.isSelected = true
        previousButton = defaultButton
        selectedPet = pets[0]
        //setting the labels
        let nameDict = selectedPet["name"] as! NSMutableDictionary
        let sexDict = selectedPet["sex"] as! NSMutableDictionary
        let ageDict = selectedPet["age"] as! NSMutableDictionary
        let breedsDict = selectedPet["breeds"] as! NSMutableDictionary
        var breedDict = breedsDict["breed"] as? [NSMutableDictionary] ?? []
        if breedDict.isEmpty {
            breedDict = [breedsDict["breed"] as! NSMutableDictionary]
        }
        let name = nameDict["$t"] as! String
        //let breed = selectedPet["breed"] as! String
        let sex = sexDict["$t"] as! String
        let age = ageDict["$t"] as! String
        petNameLabel.text = name
        var breed = ""
        for i in 0..<(breedDict.count - 1) {
            let breedName = breedDict[i]["$t"] as! String
            breed = breed + breedName + ", "
        }
        let lastBreedName = breedDict[breedDict.count - 1]["$t"] as! String
        breed = breed + lastBreedName
        breedLabel.text = breed
        ageLabel.text = age
        if sex == "M" {
            sexLabel.text = "Male"
        } else {
            sexLabel.text = "Female"
        }
        //sexLabel.text = sex
        
    }
    @objc func buttonPressed(_ sender: UIButton) {
        let selectedButton: UIButton = sender
        
        selectedButton.isSelected = true
        if previousButton != selectedButton {
            previousButton.isSelected = false
        }
        previousButton = selectedButton
        
        selectedPet = pets[selectedButton.tag]
        let nameDict = selectedPet["name"] as! NSMutableDictionary
        let sexDict = selectedPet["sex"] as! NSMutableDictionary
        let ageDict = selectedPet["age"] as! NSMutableDictionary
        let breedsDict = selectedPet["breeds"] as! NSMutableDictionary
        var breedDict = breedsDict["breed"] as? [NSMutableDictionary] ?? []
        if breedDict.isEmpty {
            breedDict = [breedsDict["breed"] as! NSMutableDictionary]
        }
        let name = nameDict["$t"] as! String
        //let breed = selectedPet["breed"] as! String
        let sex = sexDict["$t"] as! String
        let age = ageDict["$t"] as! String
        petNameLabel.text = name
        var breed = ""
        for i in 0..<(breedDict.count - 1) {
            let breedName = breedDict[i]["$t"] as! String
            breed = breed + breedName + ", "
        }
        let lastBreedName = breedDict[breedDict.count - 1]["$t"] as! String
        breed = breed + lastBreedName
        breedLabel.text = breed
        ageLabel.text = age
        if sex == "M" {
            sexLabel.text = "Male"
        } else {
            sexLabel.text = "Female"
        }
        //sexLabel.text = sex
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x <= 5 {
            leftButton.isHidden = true
            rightButton.isHidden = false
        }
        else if scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width) - 5 {
            leftButton.isHidden = false
            rightButton.isHidden = true
        }
        else {
            leftButton.isHidden = false
            rightButton.isHidden = false
        }
    }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
