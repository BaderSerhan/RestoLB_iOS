//
//  makeOrderViewController.swift
//  MRCH
//
//  Created by Eiiit on 8/2/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import IQKeyboardManagerSwift

var fromOrder = false

class makeOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate{
    
    @IBOutlet weak var noname: UITextField!
    @IBOutlet weak var nonumber: UITextField!
    @IBOutlet weak var noemail: UITextField!
    @IBOutlet weak var nameAndNumberView: UIView!
    @IBOutlet weak var ToAddressLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var makeorderButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dropDownMenuButton: UIButton!
    @IBOutlet weak var dropDownMenuTableView: UITableView!
    
    var name = ""
    var number = ""
    var email = ""
    var deliveryNotes = ""
    var total_price = preferences.integer(forKey: "TotalPrice")
    
    var selectedID = 0
    
    var arrayOfItems = [[String:Any]]()
    
    var numberOfAddresses = 0
    var ArrayOfAddresses =  [userAddressClassModel]()
    var address = userAddressClassModel()
    typealias JSONStandard = Dictionary<String, AnyObject>
    
     func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func dropDownMenuButtonAction(_ sender: Any) {
        if dropDownMenuTableView.isHidden == true{
            dropDownMenuTableView.isHidden = false
        }else{
            dropDownMenuTableView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addBackground()
        IQKeyboardManager.sharedManager().enable = false
        
        noname.isUserInteractionEnabled = false
        nonumber.isUserInteractionEnabled = false
        noemail.isUserInteractionEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.makeorderButton.isEnabled = false
        self.makeorderButton.layer.backgroundColor = UIColor.gray.cgColor
        
        if preferences.object(forKey: "CurrentOrder") != nil {
            arrayOfItems = preferences.object(forKey: "CurrentOrder") as! [[String : Any]]
        }
        
        self.descriptionTextView.placeholder = "Delivery Notes"
        
        self.dropDownMenuTableView.isHidden = true
        self.dropDownMenuTableView.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.dropDownMenuTableView.layer.borderWidth = 0.5
        
        self.dropDownMenuTableView.layer.shadowColor = colors.RestoDefaultColor.cgColor
        self.dropDownMenuTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.dropDownMenuTableView.layer.shadowRadius = 2.0
        self.dropDownMenuTableView.layer.shadowOpacity = 1
        
        self.dropDownMenuTableView.layer.cornerRadius = 8.0
        
        self.dropDownMenuTableView.clipsToBounds = true
        self.dropDownMenuTableView.layer.masksToBounds = true
        
        self.nameAndNumberView.layer.borderWidth = 1
        self.nameAndNumberView.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.nameAndNumberView.layer.cornerRadius = 8.0
        
        self.ToAddressLabel.layer.borderWidth = 1
        self.ToAddressLabel.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.ToAddressLabel.layer.cornerRadius = 6.0
        
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.descriptionTextView.layer.cornerRadius = 8.0
        
        self.dropDownMenuButton.layer.borderWidth = 1
        self.dropDownMenuButton.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.dropDownMenuButton.layer.cornerRadius = 6.0
        
        self.cancelButton.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.cancelButton.layer.borderWidth = 1.0
        self.cancelButton.layer.cornerRadius = 5.0
        
        self.makeorderButton.layer.cornerRadius = 5.0
        
        name = preferences.object(forKey: "facebooknamekey") as! String
        number = preferences.object(forKey: "facebookmobilekey") as! String
        email = preferences.object(forKey: "facebookemailkey") as! String
        
        noname.text = name
        nonumber.text = number
        noemail.text = email
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let myurl = URLs.addressURL + preferences.string(forKey: "sessiontokenkey")!
        
        self.ArrayOfAddresses.removeAll()
        Alamofire.request(myurl).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard,
                let dataArray = dict["data"] as? [JSONStandard]{
                if dataArray.count == 0 {
                    let alertController = UIAlertController(title: "Address is Required.", message: "Please add your address in the Address View.", preferredStyle: .alert)
                    let alert = UIAlertAction(title: "Add Address", style: .default){
                        UIAlertAction in
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "addaddressview")
                        self.navigationController!.pushViewController(vc, animated: true)
                    }
                    alertController.addAction(alert)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    for i in 0 ..< dataArray.count{
                        let tempAddress = userAddressClassModel()
                        
                        let thistitle = (dataArray[i]["title"] as? String)
                        if thistitle != nil{
                            tempAddress.settitle((dataArray[i]["title"] as? String)!)
                        }
                        
                        tempAddress.setID((dataArray[i]["id"] as! Int))
                        
                        self.ArrayOfAddresses.append(tempAddress)
                        self.dropDownMenuTableView.reloadData()
                    }
                }
            }
        })
        dropDownMenuTableView.dataSource = self
        dropDownMenuTableView.delegate = self
        descriptionTextView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.descriptionTextView.placeholder = ""
        if !dropDownMenuTableView.isHidden {
            dropDownMenuTableView.isHidden = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ArrayOfAddresses.count// numberOfAddresses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.dropDownMenuTableView.dequeueReusableCell(withIdentifier: "cellOfDropDownMenu")!
        cell.textLabel?.text = self.ArrayOfAddresses[indexPath.row].gettitle()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.textColor = colors.RestoDefaultColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dropDownMenuButton.setTitle(self.ArrayOfAddresses[indexPath.row].gettitle(), for: .normal)
        self.selectedID = self.ArrayOfAddresses[indexPath.row].getID()
        self.dropDownMenuTableView.isHidden = true
        self.makeorderButton.isEnabled = true
        self.makeorderButton.layer.backgroundColor = colors.RestoDefaultColor.cgColor
    }
    
    @IBAction func cancelbtnPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func makeOrder(_ sender: UIButton) {
        self.view.makeToastActivity(.center)
        name = noname.text!
        number = nonumber.text!
        deliveryNotes = descriptionTextView.text
        
        let ordersURL = URLs.orderURL + preferences.string(forKey: "sessiontokenkey")!
        
        /*
         address_id
         deliverynotes
         totalprice
         items
         
         */
        
        if total_price < 20000 {
            total_price += 1000
        }
        
        var item = [[String:Any]]()
        var optType = [[String:Any]]()
        
        for i in 0..<arrayOfItems.count{
            
            if let arrayOfOptions = arrayOfItems[i]["options"] as? NSArray{
                if(arrayOfOptions.count != 0){
                    for j in 0..<arrayOfOptions.count {
                        var optDic = arrayOfOptions[j] as! [String:Any]
                        let optID = optDic["optionID"] as! Int
                        let typeID = optDic["typeID"] as! Int
                        optType.append(["option_id": optID, "option_type": typeID])
                    }
                }
            }
            item.append(["item_id": self.arrayOfItems[i]["foodID"]!,
                    "quantity": self.arrayOfItems[i]["quantity"]!,
                    "note": self.arrayOfItems[i]["itemNote"] ?? "",
                    "options": optType])
            optType.removeAll()
        }
        let jsonEntry = [
            "address_id": self.selectedID,
            "delivery_notes": deliveryNotes,
            "total_price":total_price,
            "items": item] as [String : Any]
        print (JSON(jsonEntry))
        
        var style = ToastStyle()
        style.backgroundColor = colors.RestoDefaultColor
        style.titleColor = UIColor.white
        style.messageColor = UIColor.white
        style.cornerRadius = 5.0
        ToastManager.shared.tapToDismissEnabled = true
        
        Alamofire.request(ordersURL, method: .post, parameters: jsonEntry, encoding: JSONEncoding.default).responseJSON { response in
            if let value = response.result.value {
                print(value)
                let jsonContent = JSON(value)
                print(jsonContent)
                fromOrder = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clearTray"), object: nil)
            
                self.view.hideToastActivity()
                self.view.makeToast("You can track your order in  your Order History Page.", duration: 2.5, position: self.descriptionTextView.center, title: "Order Submitted Successfully", image: nil, style: style,completion: {Void in
                self.navigationController?.popToRootViewController(animated: true)
                })
            }else {
                print ("Couldn't get result")
                self.view.hideToastActivity()
                self.view.makeToast("There was a problem submitting your order. Please try again later.", duration: 2, position: self.descriptionTextView.center, style: style)
            }
        }
    }
}
