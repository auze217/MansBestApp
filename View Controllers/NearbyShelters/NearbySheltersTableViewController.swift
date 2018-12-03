//
//  NearbySheltersTableViewController.swift
//  MansBestApp
//
//  Created by Austin Connor Zensen on 11/10/18.
//  Copyright © 2018 Conner Caprio. All rights reserved.
//

import UIKit
import CoreLocation

class NearbySheltersTableViewController: UITableViewController, CLLocationManagerDelegate {

    //cariables for getting user location
    var locationManager = CLLocationManager();
    var userAuthorizedLocationMonitoring = false
    var location = String()
    var placeMarks = [CLPlacemark]()
    
    var applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var shelterKeys = [String]()
    var shelters: [NSMutableDictionary] = [NSMutableDictionary]()
    var shelterInfo: NSMutableDictionary = NSMutableDictionary()
    
    var apiKey = "166ad61e92ce53ba290b0da71abe7fd5"
    @IBOutlet var shelterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !applicationDelegate.userAuthorizedLocationMonitoring {
            showAlertMessage(messageHeader: "Location Services Disabled!", messageBody: "Turn Location Services On in your device settings to be able to use location services!")
        } else {
            placeMarks = applicationDelegate.placeMarks
            location = applicationDelegate.location
            locationManager = applicationDelegate.locationManager
            userAuthorizedLocationMonitoring = applicationDelegate.userAuthorizedLocationMonitoring
            setUp()
        }
       /* //location services is disbled.
        if !CLLocationManager.locationServicesEnabled() {
            showAlertMessage(messageHeader: "Location Services Disabled!", messageBody: "Turn Location Services On in your device settings to be able to use location services!")
            return
        }
        //requesting location
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            userAuthorizedLocationMonitoring = false
        } else {
            userAuthorizedLocationMonitoring = true
        }
        //check to see if the user allowed access to location
        if !userAuthorizedLocationMonitoring {
            showAlertMessage(messageHeader: "Authorization Denied!", messageBody: "Unable to determine current location!")
            return
        } else {
            locationManager.delegate = self
            
            locationManager.distanceFilter = kCLHeadingFilterNone
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.startUpdatingLocation()
            
            if !placeMarks.isEmpty {
                showAlertMessage(messageHeader: "Your Location is ", messageBody: "\(placeMarks[0].postalCode!)")
            }
        }
        //get location to get a radius
        */
        
    }
    //delegate methods
    //new location is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastObjectAtIndex = locations.count - 1
        let currentLocation: CLLocation = locations[lastObjectAtIndex] as CLLocation
        //use this to get zipcode from latitude and longitude from CLLocation
        let geoCoder: CLGeocoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler:
        { (placemarks, error) in
            if error != nil {
                self.showAlertMessage(messageHeader: "Failed to get your location", messageBody: "\(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            if pm.count > 0 {
                self.placeMarks = pm
                self.setUp()
            }
        })
        manager.stopUpdatingLocation()
        locationManager.delegate = nil
        //viewDidLoad()
        //setUp()
        
    }
    func setUp() {
        if !placeMarks.isEmpty {
            //showAlertMessage(messageHeader: "Your Location is ", messageBody: "\(placeMarks[0].postalCode!)")
            let apiString = "http://api.petfinder.com/shelter.find?key=\(apiKey)&location=\(placeMarks[0].postalCode!)&count=25&format=json"
            let apiUrl = URL(string: apiString)
            let jsonData: Data?
            do {
                jsonData = try Data(contentsOf: apiUrl!, options: NSData.ReadingOptions.mappedIfSafe)
            } catch {
                showAlertMessage(messageHeader: "Error Calling PetFinder API", messageBody: "There was an error trying to get shelters near you.")
                return
            }
            if let jsonDataFromURL = jsonData {
                //successfully obtained json data
                do {
                    let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromURL, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    let shelterDictionary = jsonDataDictionary as! Dictionary<String, AnyObject>
                    let test = shelterDictionary["petfinder"]!["shelters"] as! Dictionary<String, AnyObject>
                    shelters = test["shelter"] as! [NSMutableDictionary]
                    //shelterKeys = shelters.allKeys as! [String]
                    //shelterKeys.sort{$0 < $1}
                    
                } catch let error as NSError {
                    showAlertMessage(messageHeader: "There was an error accessing the data from the Pet Finder API", messageBody: "Error details: \(error.localizedDescription)")
                    return
                }
               
            }
            shelterTableView.reloadData()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        showAlertMessage(messageHeader: "Unable to Locate You!", messageBody: "AN error occurred while trying to determine your location: \(error.localizedDescription)")
        return
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shelters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterTableCell", for: indexPath)
        //cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "ShelterTableCell")
        let rowNumberIndex = (indexPath as NSIndexPath).row
        let shelter = shelters[rowNumberIndex]
        let test = shelter["name"] as! NSMutableDictionary
        let nameString = test["$t"] as! String
        cell.textLabel!.text = nameString
        
        let addressDict = shelter["address1"] as! NSMutableDictionary
        let cityDict = shelter["city"] as! NSMutableDictionary
        let stateDict = shelter["state"] as! NSMutableDictionary
        let zipDict = shelter["zip"] as! NSMutableDictionary

        let address = addressDict["$t"] as? String ?? ""
        let city = cityDict["$t"] as? String ?? ""
        let state = stateDict["$t"] as? String ?? ""
        let zip = zipDict["$t"] as? String ?? ""
        //let addressArray = [address, city, state, zip]
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
        //let addressString = "\(address), \(city), \(state) \(zip)"
        cell.detailTextLabel!.text = addressString
        
        return cell
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
    // Tapping a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        shelterInfo = shelters[rowNumber]
        
        performSegue(withIdentifier: "Shelter Info", sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Shelter Info" {
            let shelterInfoViewController: ShelterInfoViewController = segue.destination as! ShelterInfoViewController
            
            shelterInfoViewController.shelterInfo = shelterInfo
        }
        if segue.identifier == "Shelter Map" {
            let shelterMapViewController: ShelterMapViewController = segue.destination as! ShelterMapViewController
        }
    }

}
