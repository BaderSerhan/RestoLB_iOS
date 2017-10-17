//
//  ViewController.swift
//  MRCH
//
//  Created by mrn on 3/7/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import CoreLocation

var currentLocation : CLLocation?
class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var latitude : Double = 0
    var longitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        perform(#selector(ViewController.showmainmenu), with: nil, afterDelay: 2)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = locValue.latitude
        //preferences.set(latitude, forKey: "Latitude")
        preferences.set(latitude, forKey: "CurrentLatitude")
        longitude = locValue.longitude
        //preferences.set(longitude, forKey: "Longitude")
        preferences.set(longitude, forKey: "CurrentLongitude")
        preferences.synchronize()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
        let errorAlert = UIAlertController(title: "Error", message: "Failed to Get Your Location", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        errorAlert.addAction(okButton)
        errorAlert.addAction(cancelButton)
        self.present(errorAlert, animated: true, completion: nil)
    }
    
     func showmainmenu() {
        performSegue(withIdentifier: "gotoMenu", sender: self)
        //print ("Seague performed")
    }
}

