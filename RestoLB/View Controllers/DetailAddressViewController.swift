//
//  DetailAddressViewController.swift
//  MRCH
//
//  Created by Eiiit on 7/25/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import MapKit

class DetailAddressViewController: UIViewController {

    @IBOutlet weak var TitleLabel: UITextField!
    @IBOutlet weak var Line1Label: UITextField!
    @IBOutlet weak var Line2Label: UITextField!
    @IBOutlet weak var Line3Label: UITextField!
    @IBOutlet weak var CityLabel: UITextField!
    @IBOutlet weak var CountryLabel: UITextField!
    @IBOutlet weak var NotesLabel: UITextField!

    var addressDetails = userAddressClassModel()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mapView: UISegmentedControl!
    @IBOutlet weak var myMap: MKMapView!
    
//    var latitude = preferences.object(forKey: "Latitude") as? Double
//    var longitude = preferences.object(forKey: "Longitude") as? Double
    
    var latitude : Double = 0
    var longitude: Double = 0
    
    @IBAction func changeMapView(_ sender: AnyObject) {
        switch mapView.selectedSegmentIndex {
        case 0:
            myMap.mapType = MKMapType.standard
        case 1:
            myMap.mapType = MKMapType.satellite
        default:
            myMap.mapType = MKMapType.standard
        }
    }
    
    func loadCurrentLocationIntoMap(){
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), 200, 200)
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        myMap.addAnnotation(annotation)
        myMap.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addBackground()
        
        myMap.showsUserLocation = true
        myMap.layer.cornerRadius = 5.0
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        
        NotesLabel.layer.borderColor = UIColor.lightGray.cgColor
        NotesLabel.layer.borderWidth = 0.5
        NotesLabel.layer.cornerRadius = 6.0
        
        TitleLabel.isUserInteractionEnabled = false
        Line1Label.isUserInteractionEnabled = false
        Line2Label.isUserInteractionEnabled = false
        Line3Label.isUserInteractionEnabled = false
        CityLabel.isUserInteractionEnabled = false
        CountryLabel.isUserInteractionEnabled = false
        NotesLabel.isUserInteractionEnabled = false
       
        self.TitleLabel.text = addressDetails.gettitle()
        self.Line1Label.text = addressDetails.getline1()
        self.Line2Label.text = addressDetails.getline2()
        self.Line3Label.text = addressDetails.getline3()
        self.CityLabel.text = addressDetails.getcity()
        self.CountryLabel.text = addressDetails.getcountry()
        self.latitude = addressDetails.getgeolat()
        self.longitude = addressDetails.getgeolon()
        self.NotesLabel.text = addressDetails.getnotes()
        
        loadCurrentLocationIntoMap()
    }
}
