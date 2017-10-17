//
//  EditAddressViewController.swift
//  MRCH
//
//  Created by Eiiit on 7/25/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import Toast_Swift

class EditAddressViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var Line1TextField: UITextField!
    @IBOutlet weak var Line2TextField: UITextField!
    @IBOutlet weak var Line3TextField: UITextField!
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var CountryTextField: UITextField!
    @IBOutlet weak var NotesTextField: UITextField!

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var locBtn: UIButton!
    
    var addressDetails = userAddressClassModel()
    var addressID = 0
    var myurl = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mapView: UISegmentedControl!
    @IBOutlet weak var myMap: MKMapView!
    
//    var latitude = preferences.object(forKey: "Latitude") as! Double
//    var longitude = preferences.object(forKey: "Longitude") as! Double
    
    var latitude : Double = 0
    var longitude: Double = 0
    
    let currentLatitude = preferences.object(forKey: "CurrentLatitude") as! Double
    let currentLongitude = preferences.object(forKey: "CurrentLongitude") as! Double
    
    var Alongitude : Double = 0
    var Alatitude : Double = 0
    
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
    
    func loadCurrentLocationIntoMap(){
        if latitude == currentLatitude && longitude == currentLongitude{
            isCurrentLocation =  true
        }else{
            isCurrentLocation = false
        }
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), 200, 200)
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        myMap.addAnnotation(annotation)
        myMap.setRegion(region, animated: true)
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        isCurrentLocation = true
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude), 200, 200)
        
        if myMap.annotations.count != 0 {
            myMap.removeAnnotations(myMap.annotations)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = currentLatitude
        annotation.coordinate.longitude = currentLongitude
        myMap.addAnnotation(annotation)
        
        myMap.setRegion(region, animated: true)
        self.locBtn.isEnabled = false
        self.locBtn.backgroundColor = UIColor.gray
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
        
        if Alatitude == self.currentLatitude && Alongitude == self.currentLongitude {
            isCurrentLocation = true
            self.locBtn.isEnabled = false
            self.locBtn.backgroundColor = UIColor.gray
        }else{
            isCurrentLocation = false
            self.locBtn.isEnabled = true
            self.locBtn.backgroundColor = colors.RestoDefaultColor
        }
        
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Alatitude, longitude: Alongitude), 200, 200)
        myMap.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addBackground()
        
        self.cancelBtn.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.cancelBtn.layer.borderWidth = 1.0
        self.cancelBtn.layer.cornerRadius = 5.0
        
        self.saveBtn.layer.cornerRadius = 5.0
        self.locBtn.layer.cornerRadius = 5.0
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        
        NotesTextField.layer.borderColor = UIColor.lightGray.cgColor
        NotesTextField.layer.borderWidth = 0.5
        NotesTextField.layer.cornerRadius = 6.0
        
        CityTextField.placeholder = "Beirut"
        CountryTextField.placeholder = "Lebanon"
        
        self.addressID = addressDetails.getID()
        self.TitleTextField.text = addressDetails.gettitle()
        self.Line1TextField.text = addressDetails.getline1()
        self.Line2TextField.text = addressDetails.getline2()
        self.Line3TextField.text = addressDetails.getline3()
        self.CityTextField.text = addressDetails.getcity()
        self.CountryTextField.text = addressDetails.getcountry()
        self.latitude = addressDetails.getgeolat()
        self.longitude = addressDetails.getgeolon()
        self.NotesTextField.text = addressDetails.getnotes()
        
        loadCurrentLocationIntoMap()
        if isCurrentLocation {
            self.locBtn.isEnabled = false
            self.locBtn.backgroundColor = UIColor.gray
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        myMap.showsUserLocation = true
        myMap.layer.cornerRadius = 5.0
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))
        gestureRecognizer.delegate = self
        myMap.addGestureRecognizer(gestureRecognizer)
        
        if preferences.object(forKey: "sessiontokenkey") != nil {
            if let sessiontoken :String = preferences.object(forKey: "sessiontokenkey") as? String{
                self.myurl = "\(URLs.putAddressURL)\(self.addressID)?token=\(sessiontoken)"
            }
        }
    }

    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SubmitEdit(_ sender: Any) {
        self.view.makeToastActivity(.center)
        if CityTextField.text == "" {
            CityTextField.text = CityTextField.placeholder
        }
        if CountryTextField.text == "" {
            CountryTextField.text = CountryTextField.placeholder
        }
        if TitleTextField.text == "" || Line1TextField.text == "" || Line2TextField.text == "" || Line3TextField.text == ""  {
            let alert:UIAlertController=UIAlertController(title: "Please Fill All Required Text Fields.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
            // Add the actions
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            var parameters = ["title": TitleTextField.text!] as [String : Any]
            
            if isCurrentLocation == true {
                print("Current Location")
                //preferences.set(currentLatitude, forKey: "Latitude")
               // preferences.set(currentLongitude, forKey: "Longitude")
                parameters["geolon"] = currentLongitude
                parameters["geolat"] = currentLatitude
            }else{
                print("Not Current Location")
                //preferences.set(Alatitude, forKey: "Latitude")
                //preferences.set(Alongitude, forKey: "Longitude")
                parameters["geolon"] = Alongitude
                parameters["geolat"] = Alatitude
            }

            parameters["line1"] = Line1TextField.text
            parameters["line2"] = Line2TextField.text
            parameters["line3"] = Line3TextField.text
            parameters["city"] = CityTextField.text
            parameters["country"] = CountryTextField.text
            parameters["notes"] = NotesTextField.text
            
            var style = ToastStyle()
            style.backgroundColor = UIColor.white
            style.titleColor = colors.RestoDefaultColor
            style.messageColor = colors.RestoDefaultColor
            style.cornerRadius = 5.0

            Alamofire.request(self.myurl, method: .put, parameters:parameters, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    if let value = response.result.value {
                        _ = JSON(value)
                        self.view.hideToastActivity()
                        self.view.makeToast("Address Updated Successfully!", duration: 2, position: .center, title: nil, image: nil, style: style,completion: {Void in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "addressView") as! AddressViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    }else {
                        self.view.hideToastActivity()
                        self.view.makeToast("Couldn't Update Address.", duration: 2, position: .center, title: "Sorry!", image: nil, style: style,completion: {Void in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "addressView") as! AddressViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    }
                    //self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
