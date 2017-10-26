//
//  AddAddressViewController.swift
//  MRCH
//
//  Created by Eiiit on 7/21/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import Toast_Swift

var isCurrentLocation = true

class AddAddressViewController: UIViewController,UIGestureRecognizerDelegate{

    @IBOutlet weak var mapView: UISegmentedControl!
    @IBOutlet weak var myMap: MKMapView!
    
    let latitude = preferences.object(forKey: "CurrentLatitude") as! Double
    let longitude = preferences.object(forKey: "CurrentLongitude") as! Double
    
    var Alongitude : Double = 0
    var Alatitude : Double = 0
    
    //add text Fields
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var line1: UITextField!
    @IBOutlet weak var line2: UITextField!
    @IBOutlet weak var line3: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var note: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var locBtn: UIButton!
    
    var myurl = String()
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
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
    
    func loadCityIntoMap(){
        let Beirut = locStruct(name: "Beirut", lat: 33.8938, long: 35.5018)
        let span = MKCoordinateSpanMake(0.075,0.075)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Beirut.lat, longitude: Beirut.long),span:span)
        myMap.setRegion(region, animated: true)
    }
    
    @IBAction func setCurrentLocation(_ sender: Any) {
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude), 200, 200)
        
        if myMap.annotations.count != 0 {
            myMap.removeAnnotations(myMap.annotations)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        myMap.addAnnotation(annotation)
        myMap.setRegion(region, animated: true)
    }
    
     @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        
        let location = gestureReconizer.location(in: myMap)
        let coordinate = myMap.convert(location,toCoordinateFrom: myMap)
        
        if myMap.annotations.count != 0 {
            myMap.removeAnnotations(myMap.annotations)
        }
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        myMap.addAnnotation(annotation)
        
        Alongitude = annotation.coordinate.longitude
        Alatitude = annotation.coordinate.latitude
        
        if Alatitude == self.latitude && Alongitude == self.longitude {
            isCurrentLocation = true
        }else{
            isCurrentLocation = false
        }
        
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Alatitude, longitude: Alongitude), 200, 200)
        myMap.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addBackground()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.longitude = longitude
        annotation.coordinate.latitude = latitude
        myMap.addAnnotation(annotation)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        loadCityIntoMap()
        
        myMap.showsUserLocation = true
        myMap.layer.cornerRadius = 5.0
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))
        gestureRecognizer.delegate = self
        myMap.addGestureRecognizer(gestureRecognizer)
        
        self.cancelBtn.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.cancelBtn.layer.borderWidth = 1.0
        self.cancelBtn.layer.cornerRadius = 5.0
        
        self.saveBtn.layer.cornerRadius = 5.0
        self.locBtn.layer.cornerRadius = 5.0
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        
        titleTxt.placeholder = "Office, Home, Gym..."
        city.placeholder = "Beirut"
        country.placeholder = "Lebanon"
        note.placeholder = "Interphone..."
        note.layer.borderColor = UIColor.lightGray.cgColor
        note.layer.borderWidth = 0.5
        note.layer.cornerRadius = 5.0
        
        if preferences.object(forKey: "sessiontokenkey") != nil {
            if let sessiontoken :String = preferences.object(forKey: "sessiontokenkey") as? String{
                myurl = URLs.addressURL + sessiontoken
                print(sessiontoken)
            }
        }
    }
    
    @IBAction func submitNewAddress(_ sender: Any) {
        self.view.makeToastActivity(.center)
        if city.text == "" {
            city.text = city.placeholder
        }
        if country.text == "" {
            country.text = country.placeholder
        }
        if titleTxt.text == "" || line1.text == "" || line2.text == "" || line3.text == ""  {
            let alert:UIAlertController=UIAlertController(title: "Please Fill All Required Text Fields.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
            // Add the actions
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            
            
            var parameters = ["title": titleTxt.text!] as [String : Any]
            
            if isCurrentLocation  {
                print("Current Location")
                //preferences.set(latitude, forKey: "Latitude")
                //preferences.set(longitude, forKey: "Longitude")
                parameters["geolon"] = longitude
                parameters["geolat"] = latitude
            }else{
                print("Not Current Location")
                //preferences.set(Alatitude, forKey: "Latitude")
                //preferences.set(Alongitude, forKey: "Longitude")
                parameters["geolon"] = Alongitude
                parameters["geolat"] = Alatitude
            }
            
                parameters["line1"] = line1.text
                parameters["line2"] = line2.text
                parameters["line3"] = line3.text
                parameters["city"] = city.text
                parameters["country"] = country.text
                parameters["notes"] = note.text
            
            var style = ToastStyle()
            style.backgroundColor = UIColor.white
            style.titleColor = colors.RestoDefaultColor
            style.messageColor = colors.RestoDefaultColor
            style.cornerRadius = 5.0
        
            Alamofire.request(myurl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    if let value = response.result.value {
                        _ = JSON(value)
                        self.view.hideToastActivity()
                        self.view.makeToast("Address Added Successfully!", duration: 2, position: .center, title: nil, image: nil, style: style,completion: {Void in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "addressView") as! AddressViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    } else{
                        self.view.hideToastActivity()
                        self.view.makeToast("Couldn't Add Address.", duration: 2, position: .center, title: nil, image: nil, style: style,completion: {Void in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "addressView") as! AddressViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    }
            }
            
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
