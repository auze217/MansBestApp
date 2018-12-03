//
//  ShelterInfoViewController.swift
//  MansBestApp
//
//  Created by Austin Connor Zensen on 11/10/18.
//  Copyright © 2018 Conner Caprio. All rights reserved.
//

import UIKit

class ShelterInfoViewController: UIViewController {

    var shelterInfo: NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet var shelterAddressLabel: UILabel!
    @IBOutlet var shelterMapSegmentedControl: UISegmentedControl!
    
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    
    var mapType = ""
    @IBAction func setMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapType = "standard"
        case 1:
            mapType = "satellite"
        case 2:
            mapType = "hybrid"
        default:
            return
        }
        performSegue(withIdentifier: "Shelter Map", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //there is no shelter image so that needs to be changed
        let test = shelterInfo["name"] as! NSMutableDictionary
        let nameString = test["$t"] as! String
        self.title = nameString
        
        //getting information for the shelters address
        let addressDict = shelterInfo["address1"] as! NSMutableDictionary
        let cityDict = shelterInfo["city"] as! NSMutableDictionary
        let stateDict = shelterInfo["state"] as! NSMutableDictionary
        let zipDict = shelterInfo["zip"] as! NSMutableDictionary
        
        let address = addressDict["$t"] as? String ?? ""
        let city = cityDict["$t"] as? String ?? ""
        let state = stateDict["$t"] as? String ?? ""
        let zip = zipDict["$t"] as? String ?? ""
        
        //phone if its there
        let phoneDict = shelterInfo["phone"] as! NSMutableDictionary
        let phone = phoneDict["$t"] as? String ?? "N/A"
        phoneLabel.text = phone
        
        //email if its there
        let emailDict = shelterInfo["email"] as! NSMutableDictionary
        let email = emailDict["$t"] as? String ?? "N/A"
        emailLabel.text = email
        var addressString = ""
        if !address.isEmpty {
            addressString = addressString + address + ", "
        }
        if !city.isEmpty {
            addressString = addressString + city + ", "
        }
        if !state.isEmpty {
            addressString = addressString + state + " "
        }
        if !zip.isEmpty {
            addressString = addressString + zip
        }
        shelterAddressLabel.text = addressString
        // Do any additional setup after loading the view.
        

        shelterMapSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Shelter Map" {
            let shelterMapViewController: ShelterMapViewController = segue.destination as! ShelterMapViewController
            shelterMapViewController.shelterInfo = shelterInfo
            shelterMapViewController.mapType = mapType
        }
    }
    

}
