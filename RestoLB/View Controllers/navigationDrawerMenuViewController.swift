//
//  navigationDrawerMenuViewController.swift
//  MRCH
//
//  Created by Eiiit on 8/3/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import FBSDKCoreKit
import Toast_Swift
import SideMenu

class navigationDrawerMenuViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var headerImage: UIImageView!
    
    var isLoggedIn : Bool = false
    
    var menuTitles: [String] = []
    let authenticateAPIURL = URLs.authenticateAPIURL
    var facebookID : Int = 0
    var email : String! = ""
    var name : String! = ""
    var mobile : String! = ""
    var accessToken : String! = ""
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        SideMenuManager.default.menuPresentMode = .menuSlideIn

        let sessiontokenkey = "sessiontokenkey"
        if preferences.object(forKey: sessiontokenkey) == nil {
            //  Doesn't exist
           menuTitles = ["Menu","Tray","Announcements", "Login"]
        } else {
            if let _:String = preferences.object(forKey: sessiontokenkey) as? String{
                menuTitles = ["Menu","Tray","Announcements", "Profile", "Addresses", "Order History", "Logout"]
            }
        }
        headerImage.superview?.layoutIfNeeded()
        //headerImage.clipsToBounds = true
        //headerImage.layer.masksToBounds = true
        //headerImage.layer.cornerRadius = headerImage.frame.width / 2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sideMenuTableView.dequeueReusableCell(withIdentifier: "sideMenuCell")!
        cell.textLabel?.text = self.menuTitles[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 24.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = sideMenuTableView.cellForRow(at: indexPath) //sideMenuTableView.cellForRowAtIndexPath(indexPath) as! UITableViewCell
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc : UIViewController!
        
        if currentCell?.textLabel?.text == "Profile"{
            vc = storyboard.instantiateViewController(withIdentifier: "profileView")
            self.dismiss(animated: true, completion: nil)
            self.navigationController!.pushViewController(vc, animated: true)
            
        }else if currentCell?.textLabel?.text == "Menu"{
            //if already in menu
            self.dismiss(animated: true, completion: nil)
            //else
//            vc = storyboard.instantiateViewController(withIdentifier: "menuView")
//            self.navigationController!.pushViewController(vc, animated: true)
            
        }else if currentCell?.textLabel?.text == "Tray"{
            let tray = storyboard.instantiateViewController(withIdentifier: "trayView") as! TrayViewController
            if preferences.array(forKey: "CurrentOrder") != nil {
                tray.arrayOfItems = preferences.array(forKey: "CurrentOrder") as! [[String : Any]]
            }
            self.dismiss(animated: true, completion: nil)
            self.navigationController!.pushViewController(tray, animated: true)
            
        }else if currentCell?.textLabel?.text == "Order History"{
            let vc = storyboard.instantiateViewController(withIdentifier: "orderHistoryView")
            self.dismiss(animated: true, completion: nil)
            self.navigationController!.pushViewController(vc, animated: true)
            
        }else if currentCell?.textLabel?.text == "Addresses"{
            let vc = storyboard.instantiateViewController(withIdentifier: "addressView")
            self.dismiss(animated: true, completion: nil)
            self.navigationController!.pushViewController(vc, animated: true)
            
        }else if currentCell?.textLabel?.text == "Announcements"{
            let vc = storyboard.instantiateViewController(withIdentifier: "announcementsView")
            self.dismiss(animated: true, completion: nil)
            self.navigationController!.pushViewController(vc, animated: true)
            
        }else if currentCell?.textLabel?.text == "Logout"{
            
            preferences.removeObject(forKey:"sessiontokenkey")
            preferences.removeObject(forKey: "facebooknamekey")
            preferences.removeObject(forKey:"facebookemailkey")
            preferences.removeObject(forKey: "facebookmobilekey")
            preferences.removeObject(forKey: "useridkey")
            isLoggedIn = false
            preferences.set(isLoggedIn, forKey: "isLoggedIn")
            
            var style = ToastStyle()
            style.backgroundColor = UIColor.white
            style.messageColor = colors.RestoDefaultColor
            style.cornerRadius = 5.0

            self.view.makeToast("You Have Been Successfully Logged Out.", duration: 1, position: .bottom, title: nil, image: nil, style: style,completion: {Void in
                self.dismiss(animated: true, completion: nil)
            })

        }else if currentCell?.textLabel?.text == "Login"{
            
            let manager = FBSDKLoginManager()
            
            manager.logIn(withReadPermissions: ["public_profile"], from: self, handler: { (result, error) -> Void in
                //if let error = error {
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    let logMeOut = FBSDKLoginManager()
                    logMeOut.logOut()
//                    let alert:UIAlertController=UIAlertController(title: "Login Failed!! Please Try Again", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
//                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
//                    {
//                        UIAlertAction in
//                    }
//                    
//                    // Add the actions
//                    alert.addAction(okAction)
//                    self.present(alert, animated: true, completion: nil)
                    print("Login Failed!! Please Try Again")
                }else{
                if (result?.isCancelled)! {
                    print("Cancelled")
                } else {
                    FBSDKGraphRequest(graphPath: "/me", parameters:["fields": "name, email, id"])
                        .start(completionHandler:  { (connection, result, error) in
                        let result = result as! Dictionary<NSString, NSString>
                            print(result)
                        
                        self.facebookID = Int(result["id"]! as String)!
                        self.name = (result["name"])! as String
                            if result["email"] != nil{
                                self.email = (result["email"])! as String
                            }

                            let getURL = "\(URLs.usersURL)\(self.facebookID)"

                            Alamofire.request(getURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                                .responseJSON(completionHandler: { response in
                                    if let value = response.result.value {
                                        let jsonContent = JSON(value)
                                        //print(jsonContent)
                                        if let dataArray = jsonContent["data"].object as? NSArray{
                                            //print(dataArray)
                                            if dataArray.count != 0 {
                                                let data = dataArray[0] as! NSDictionary
                                                if let dataMobile = data["mobile"] as? String{
                                                    self.mobile = dataMobile
                                                }
                                            
                                                if let dataEmail = data["email"] as? String{
                                                    self.email = dataEmail
                                                }
                                            
                                                if let dataName = data["name"] as? String{
                                                    self.name = dataName
                                                }
                                            }
                                        }
                                    }
                                    
                                    if self.name != ""{
                                        preferences.set(self.name, forKey: "facebooknamekey")
                                    }
                                    if self.email != ""{
                                        preferences.set(self.email, forKey: "facebookemailkey")
                                    }
                                    if self.mobile != "" {
                                        preferences.set(self.mobile, forKey: "facebookmobilekey")
                                    }
                                    preferences.synchronize()
                                })
                            
                        var parameters = [
                            "facebook": self.facebookID ,
                            "email": self.email,
                            "name": self.name,
                        ] as [String : Any]
                            
                            if let device_token = preferences.string(forKey: "device_token"){
                                parameters["device_token"] = device_token
                            }
                            
                        Alamofire.request(self.authenticateAPIURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                            .responseJSON(completionHandler: { response in
                                print(parameters)
                                if let value = response.result.value {
                                    let jsonContent = JSON(value)
                                    print(jsonContent)
                                    let sessiontoken = jsonContent["token"].string
                                    let userid = jsonContent["user_id"].int
                                    preferences.set(sessiontoken, forKey: "sessiontokenkey")
                                    preferences.set(userid, forKey: "useridkey")
                                    //  Save to disk
                                    self.isLoggedIn = true
                                    preferences.set(self.isLoggedIn, forKey: "isLoggedIn")
                                    preferences.synchronize()
                                } else {
                                    print ("Failed to authenticate")
                                }
                            })
//                            if let device_token = preferences.string(forKey: "device_token"){
//                                let parameter = ["device_token" : device_token]
//                                let myurl = "\(URLs.userIDURL)\(preferences.integer(forKey: "useridkey"))"
//                                Alamofire.request(myurl, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
//                                    .responseJSON(completionHandler: { response in
//                                        if let value = response.result.value {
//                                            let jsonContent = JSON(value)
//                                            print(jsonContent)
//                                        }
//                                    })
//                            }
                        })
                    
                    }
                }
            })
        }//end of login case
    }
}
