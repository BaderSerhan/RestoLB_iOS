//
//  profileViewController.swift
//  MRCH
//
//  Created by Eiiit on 8/10/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class profileViewController: UIViewController {

    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var nametextfield: UITextField!
    @IBOutlet weak var mobiletextfield: UITextField!
    @IBOutlet weak var emailtextfield: UITextField!
    
    let authenticateAPIURL = URLs.authenticateAPIURL
    var myurl = String()
    
    let facebooknamekey = "facebooknamekey"
    let facebookemailkey = "facebookemailkey"
    let facebookmobilekey = "facebookmobilekey"
    
     func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addBackground()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.cancelbtn.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.cancelbtn.layer.borderWidth = 1.0
        self.cancelbtn.layer.cornerRadius = 5.0
        
        self.savebtn.layer.cornerRadius = 5.0
    
        if preferences.object(forKey: facebooknamekey) != nil {
            if let facebookname :String = preferences.object(forKey: facebooknamekey) as? String{
                nametextfield.text = facebookname
            }
        }
        if preferences.object(forKey: facebookemailkey) != nil {
           if let facebookemail :String = preferences.object(forKey: facebookemailkey) as? String{
                emailtextfield.text = facebookemail
            }
        }
        if preferences.object(forKey: facebookmobilekey) != nil {
            if let mobilenumber :String = preferences.object(forKey: facebookmobilekey) as? String{
                mobiletextfield.text = mobilenumber
            }
        }
    }

    @IBAction func savebtnpressed(_ sender: Any) {
        let facebookname = self.nametextfield.text
        let facebookemail = self.emailtextfield.text
        let mobilenumber = self.mobiletextfield.text
        preferences.set(facebookname, forKey: facebooknamekey)
        preferences.set(facebookemail, forKey: facebookemailkey)
        preferences.set(mobilenumber, forKey: facebookmobilekey)
        //  Save to disk
        preferences.synchronize()
        
        if preferences.string(forKey: facebooknamekey) == "" {
            let alertController = UIAlertController(title: "Name is Required.", message: "Please enter your name.", preferredStyle: .alert)
            let alert = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alert)
            self.present(alertController, animated: true, completion: nil)
        }

        else if preferences.string(forKey: facebookemailkey) == "" {
            let alertController = UIAlertController(title: "Email is Required.", message: "Please enter your email.", preferredStyle: .alert)
            let alert = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alert)
            self.present(alertController, animated: true, completion: nil)
        }

        else if preferences.string(forKey: facebookmobilekey) == "" {
            let alertController = UIAlertController(title: "Mobile is Required.", message: "Please enter your mobile.", preferredStyle: .alert)
            let alert = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alert)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
        
        let useridkey = "useridkey"
        if preferences.object(forKey: useridkey) != nil {
            if let user_ID = preferences.object(forKey: "useridkey") as? Int{
                self.myurl = "\(URLs.userIDURL)\(user_ID)"
                
                let parameters = [
                    "mobile": mobilenumber!,
                    "email": facebookemail!,
                    "name": facebookname!
                    ] as [String : Any]
                
                Alamofire.request(myurl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                    .responseJSON(completionHandler: { response in
                        if response.result.value != nil {
                            self.navigationController!.popViewController(animated: true)
                        }
                        else { print ("error")}
                    })
                }
            }
        }
    }
    
    @IBAction func cancelbtnPressed(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
