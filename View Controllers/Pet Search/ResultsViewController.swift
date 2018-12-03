//
//  ResultsViewController.swift
//  MansBestApp
//
//  Created by Austin Connor Zensen on 11/26/18.
//  Copyright © 2018 Conner Caprio. All rights reserved.
//

import UIKit
import CoreLocation
class ResultsViewController: UIViewController {

    var applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var placeMark = ""
    var petInfo: NSMutableDictionary = NSMutableDictionary()
    var pets = [NSMutableDictionary]()
    var selectedPet: NSMutableDictionary = NSMutableDictionary()
    var previousButton: UIButton = UIButton()
    var apiKey = "166ad61e92ce53ba290b0da71abe7fd5"
    var selectedIndex = 0
    @IBOutlet var petImageView: UIImageView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var petBreedLabel: UILabel!
    @IBOutlet var petAgeLabel: UILabel!
    @IBOutlet var petSexLabel: UILabel!
    @IBOutlet var moreInfoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if applicationDelegate.userAuthorizedLocationMonitoring {
        // Do any additional setup after loading the view.
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
        placeMark = applicationDelegate.placeMarks[0].postalCode!
        var apiString = "http://api.petfinder.com/pet.find?key=\(apiKey)&animal=\(petType)&location=\(placeMark)"
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
            let breedString = breed.replacingOccurrences(of: " ", with: "+")
            apiString = apiString + "&breed=\(breedString)"
        }
        //get the full description of the dog and put the format as a json
        apiString = apiString + "&count=30&format=json"
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
        }
    }
    func setUp() {
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
        petBreedLabel.text = breed
        petAgeLabel.text = age
        /*if sex == "M" {
            petSexLabel.text = "Male"
        } else {
            petSexLabel.text = "Female"
        }*/
        petSexLabel.text = sex
        //setting the image
        let petMedia = selectedPet["media"] as! NSMutableDictionary
        let petPhotosDict = petMedia["photos"] as! NSMutableDictionary
        let petPhotos = petPhotosDict["photo"] as! [NSMutableDictionary]
        let imageString = petPhotos[2]["$t"] as! String
        let imageUrl = URL(string: imageString)
        //let petImage = UIImage(named: imageString)
        //var petImage :UIImage
        let imageData: Data?
        do {
            imageData = try Data(contentsOf: imageUrl!)
            petImageView.image = UIImage(data: imageData!)
        } catch {
            petImageView.image = UIImage(named: "ben.jpg")
        }
        leftButton.isHidden = true
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        selectedIndex = selectedIndex - 1
        selectedPet = pets[selectedIndex]
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
        petBreedLabel.text = breed
        petAgeLabel.text = age
        /*if sex == "M" {
            petSexLabel.text = "Male"
        } else {
            petSexLabel.text = "Female"
        }*/
        petSexLabel.text = sex
        
        //setting the image
        let petMedia = selectedPet["media"] as! NSMutableDictionary
        if !petMedia.allKeys.isEmpty {
            let petPhotosDict = petMedia["photos"] as! NSMutableDictionary
            let petPhotos = petPhotosDict["photo"] as! [NSMutableDictionary]
            let imageString = petPhotos[2]["$t"] as! String
            let imageUrl = URL(string: imageString)
            //let petImage = UIImage(named: imageString)
            //var petImage :UIImage
            let imageData: Data?
            do {
                imageData = try Data(contentsOf: imageUrl!)
                petImageView.image = UIImage(data: imageData!)
            } catch {
                petImageView.image = UIImage(named: "ben.jpg")
            }
        } else{
            //there are no photos so use image unavailable
            petImageView.image = UIImage(named: "ben.jpg")
        }
        if selectedIndex == 0 {
            leftButton.isHidden = true
        } else {
            leftButton.isHidden = false
        }
        if selectedIndex == pets.count - 1 {
            rightButton.isHidden = true
        } else {
            rightButton.isHidden = false
        }
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        selectedIndex = selectedIndex + 1
        selectedPet = pets[selectedIndex]
        
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
        petBreedLabel.text = breed
        petAgeLabel.text = age
        /*if sex == "M" {
            petSexLabel.text = "Male"
        } else {
            petSexLabel.text = "Female"
        }*/
        petSexLabel.text = sex
        
        //setting the image
        let petMedia = selectedPet["media"] as! NSMutableDictionary
        if !petMedia.allKeys.isEmpty {
            let petPhotosDict = petMedia["photos"] as! NSMutableDictionary
            let petPhotos = petPhotosDict["photo"] as! [NSMutableDictionary]
            let imageString = petPhotos[2]["$t"] as! String
            let imageUrl = URL(string: imageString)
            //let petImage = UIImage(named: imageString)
            //var petImage :UIImage
            let imageData: Data?
            do {
                imageData = try Data(contentsOf: imageUrl!)
                petImageView.image = UIImage(data: imageData!)
            } catch {
                petImageView.image = UIImage(named: "ben.jpg")
            }
        } else{
            //there are no photos so use image unavailable
            petImageView.image = UIImage(named: "ben.jpg")
        }
        if selectedIndex == pets.count - 1 {
            rightButton.isHidden = true
        } else {
            rightButton.isHidden = false
        }
        if selectedIndex == 0 {
            leftButton.isHidden = true
        } else {
            leftButton.isHidden = false
        }
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "Pet Info", sender: self)
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Pet Info" {
            let petMedia = selectedPet["media"] as! NSMutableDictionary
            let petPhotosDict = petMedia["photos"] as! NSMutableDictionary
            let petPhotos = petPhotosDict["photo"] as! [NSMutableDictionary]
            let imageString = petPhotos[2]["$t"] as! String
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
            //getting the description
            let descriptionDict = selectedPet["description"] as! NSMutableDictionary
            let description = descriptionDict["$t"] as! String
            //getting the contact info
            let contactDict = selectedPet["contact"] as! NSMutableDictionary
            var contactString = ""
            //getting all of the items in the contact dictionary and adding it to the string to pass
            //address
            let addressDict = contactDict["address1"] as! NSMutableDictionary
            let address2Dict = contactDict["address2"] as! NSMutableDictionary
            let cityDict = contactDict["city"] as! NSMutableDictionary
            let stateDict = contactDict["state"] as! NSMutableDictionary
            let zipDict = contactDict["zip"] as! NSMutableDictionary
            contactString = contactString + "Address: \(addressDict["$t"] as? String ?? "")  \(address2Dict["$t"] as? String ?? "") \(cityDict["$t"] as? String ?? ""), \(stateDict["$t"] as? String ?? "") \(zipDict["$t"] as? String ?? "")\n"
            //phone
            let phoneDict = contactDict["phone"] as! NSMutableDictionary
            let emailDict = contactDict["email"] as! NSMutableDictionary
            contactString = contactString + "Phone Number: \(phoneDict["$t"] as? String ?? "")\n"
            contactString = contactString + "E-mail: \(emailDict["$t"] as? String ?? "")\n"
            let petInfoToPass = [name, sex, age, breed, imageString, description, contactString]
            
            let petInfoViewController: PetInfoViewController = segue.destination as! PetInfoViewController
            petInfoViewController.petInfoToPass = petInfoToPass
        }
    }
    

}
