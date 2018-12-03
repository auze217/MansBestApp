//
//  AppDelegate.swift
//  MansBestApp
//
//  Created by Conner Joseph Caprio on 10/30/18.
//  Copyright © 2018 Conner Caprio. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    var locationManager = CLLocationManager();
    var userAuthorizedLocationMonitoring = false
    var location = String()
    var placeMarks = [CLPlacemark]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //location services is disbled.
        if !CLLocationManager.locationServicesEnabled() {
            //showAlertMessage(messageHeader: "Location Services Disabled!", messageBody: "Turn Location Services On in your device settings to be able to use location services!")
            return false
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
            //showAlertMessage(messageHeader: "Authorization Denied!", messageBody: "Unable to determine current location!")
            return false
        } else {
            locationManager.delegate = self
            
            locationManager.distanceFilter = kCLHeadingFilterNone
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.startUpdatingLocation()
            
        }
        return true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastObjectAtIndex = locations.count - 1
        let currentLocation: CLLocation = locations[lastObjectAtIndex] as CLLocation
        //use this to get zipcode from latitude and longitude from CLLocation
        let geoCoder: CLGeocoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler:
            { (placemarks, error) in
                if error != nil {
                    //self.showAlertMessage(messageHeader: "Failed to get your location", messageBody: "\(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    self.placeMarks = pm
                    //self.setUp()
                }
        })
        manager.stopUpdatingLocation()
        locationManager.delegate = nil
        //viewDidLoad()
        //setUp()
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

