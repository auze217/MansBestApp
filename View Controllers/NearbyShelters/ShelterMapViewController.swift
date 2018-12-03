//
//  ShelterMapViewController.swift
//  MansBestApp
//
//  Created by Austin Connor Zensen on 11/10/18.
//  Copyright © 2018 Conner Caprio. All rights reserved.
//

import UIKit
import WebKit
import MapKit
import CoreLocation

class ShelterMapViewController: UIViewController, MKMapViewDelegate {

    var shelterInfo: NSMutableDictionary = NSMutableDictionary()
    var mapType = ""
    
    //let vtCampusCenterLocation = CLLocationCoordinate2D(latitude: 37.227778, longitude: -80.422014)
    var shelterCenterLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    // The amount of north-to-south distance (measured in meters) to use for the span.
    let latitudinalSpanInMeters: Double = 1609.344    // = 1 mile
    
    // The amount of east-to-west distance (measured in meters) to use for the span.
    let longitudinalSpanInMeters: Double = 1609.344   // = 1 mile
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nameDict = shelterInfo["name"] as! NSMutableDictionary
        let name = nameDict["$t"] as! String
        self.title = name
        
        //getting information for the shelters address
        let addressDict = shelterInfo["address1"] as! NSMutableDictionary
        let cityDict = shelterInfo["city"] as! NSMutableDictionary
        let stateDict = shelterInfo["state"] as! NSMutableDictionary
        let zipDict = shelterInfo["zip"] as! NSMutableDictionary
        
        let address = addressDict["$t"] as? String ?? ""
        let city = cityDict["$t"] as? String ?? ""
        let state = stateDict["$t"] as? String ?? ""
        let zip = zipDict["$t"] as? String ?? ""
        let addressString = "\(address), \(city), \(state) \(zip)"
        
        let latitudeDict = shelterInfo["latitude"] as! NSMutableDictionary
        let longitudeDict = shelterInfo["longitude"] as! NSMutableDictionary
        
        let latitude = latitudeDict["$t"] as! String
        let longitude = longitudeDict["$t"] as! String
        let lat = Double(latitude)
        let long = Double(longitude)
        if(lat == -1.0 || long == -1.0) {
            
            //show error getting latitude and longitude
            return
        }
        shelterCenterLocation = CLLocationCoordinate2DMake(lat!, long!)
        
        //setting mapType
        if mapType == "satellite" {
            mapView.mapType = MKMapType.satellite
        }
        else if mapType == "hybrid" {
            mapView.mapType = MKMapType.hybrid
        }
        else {
            mapView.mapType = MKMapType.standard
        }
        
        let mapRegion: MKCoordinateRegion? = MKCoordinateRegion(center: shelterCenterLocation, latitudinalMeters: latitudinalSpanInMeters, longitudinalMeters: longitudinalSpanInMeters)
        
        mapView.setRegion(mapRegion!, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = shelterCenterLocation
        annotation.title = name
        annotation.subtitle = addressString
        
        mapView.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        // Starting to load the map. Show the animated activity indicator in the status bar
        // to indicate to the user that the map view object is busy loading the map.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        // Finished loading the map. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        
        // An error occurred during the map load. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alertController = UIAlertController(title: "Unable to Load the Map!",
                                                message: "Error description: \(error.localizedDescription)",
            preferredStyle: UIAlertController.Style.alert)
        
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
