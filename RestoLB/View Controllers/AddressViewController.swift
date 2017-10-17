//
//  AddressViewController.swift
//  MRCH
//
//  Created by Eiiit on 7/21/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class AddressViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var AddressTableView: UITableView!
    var myurl = String()
    var numberOfAddresses = 0
    var noAddresses : Bool = false
    
    var ArrayOfAddresses =  [userAddressClassModel]()
    var address = userAddressClassModel()
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    func noAddressesAlertController () {
        let alertController = UIAlertController(title: "You Don't Have Any Addresses Yet.", message: "Please add an address.", preferredStyle: .alert)
        let alert = UIAlertAction(title: "Add Address", style: .default){
            UIAlertAction in
            self.performSegue(withIdentifier: "gotoAddView", sender: UIAlertAction)
        }
        alertController.addAction(alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func returntoRoot(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addBackground()
        //self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "TILE marrouche 2"))
        
        self.AddressTableView.delegate = self
        self.AddressTableView.dataSource = self
        
        self.view.makeToastActivity(.top)
        if preferences.object(forKey: "sessiontokenkey") != nil {
            if let sessiontoken :String = preferences.object(forKey: "sessiontokenkey") as? String{
                let myurl = URLs.addressURL + sessiontoken
                
                Alamofire.request(myurl).responseJSON(completionHandler: {
                    response in
                    let result = response.result
                    
                    if let dict = result.value as? JSONStandard,
                        let dataArray = dict["data"] as? [JSONStandard]{
                        if dataArray.count == 0 {
                            self.noAddresses = true
                            self.noAddressesAlertController()
                        }else {
                            for i in 0 ..< dataArray.count{
                                let tempAddress = userAddressClassModel()
                                tempAddress.setID((dataArray[i]["id"] as? Int)!)
                                tempAddress.setuserid((dataArray[i]["user_id"] as? Int)!)
                                let thistitle = (dataArray[i]["title"] as? String)
                                if thistitle != nil{
                                    tempAddress.settitle((dataArray[i]["title"] as? String)!)
                                }
                                let thisline1 = (dataArray[i]["line1"] as? String)
                                if thisline1 != nil{
                                    tempAddress.setline1((dataArray[i]["line1"] as? String)!)
                                }
                                let thisline2 = (dataArray[i]["line2"] as? String)
                                if thisline2 != nil{
                                    tempAddress.setline2((dataArray[i]["line2"] as? String)!)
                                }
                                let thisline3 = (dataArray[i]["line3"] as? String)
                                if thisline3 != nil{
                                    tempAddress.setline3((dataArray[i]["line3"] as? String)!)
                                }
//                                let thispostcode = (dataArray[i]["postcode"] as? String)
//                                if thispostcode != nil{
//                                    tempAddress.setpostcode(postcode: (dataArray[i]["postcode"] as? String)!)
//                                }
                                let thiscity = (dataArray[i]["city"] as? String)
                                if thiscity != nil{
                                    tempAddress.setcity((dataArray[i]["city"] as? String)!)
                                }
                                let thiscountry = (dataArray[i]["country"] as? String)
                                if thiscountry != nil{
                                    tempAddress.setcountry((dataArray[i]["country"] as? String)!)
                                }
                                
                                let thislon = (dataArray[i]["geolon"] as? Float)
                                if thislon != nil{
                                    tempAddress.setgeolon(Double(thislon!))
                                }
                                let thislat = (dataArray[i]["geolat"] as? Float)
                                if thislat != nil{
                                    tempAddress.setgeolat(Double(thislat!))
                                }
                                
                                let thisnotes = (dataArray[i]["notes"] as? String)
                                if thisnotes != nil{
                                    tempAddress.setnotes((dataArray[i]["notes"] as? String)!)
                                }
                                self.ArrayOfAddresses.append(tempAddress)
                                self.view.hideToastActivity()
                                self.AddressTableView.reloadData()
                            }
                        }
                    }
                })
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayOfAddresses.count// numberOfAddresses
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressTableViewCellViewController = self.AddressTableView.dequeueReusableCell(withIdentifier: "Cell")! as! AddressTableViewCellViewController

        cell.detailsAddressBtn.clipsToBounds = true
        cell.detailsAddressBtn.layer.masksToBounds = true
        cell.detailsAddressBtn.layer.cornerRadius = cell.detailsAddressBtn.frame.width / 2
        
        cell.editAddressBtn.clipsToBounds = true
        cell.editAddressBtn.layer.masksToBounds = true
        cell.editAddressBtn.layer.cornerRadius = cell.detailsAddressBtn.frame.width / 2
        
        cell.deleteAddressBtn.clipsToBounds = true
        cell.deleteAddressBtn.layer.masksToBounds = true
        cell.deleteAddressBtn.layer.cornerRadius = cell.detailsAddressBtn.frame.width / 2
        
        cell.Column1.text = self.ArrayOfAddresses[indexPath.row].gettitle()
        cell.deleteAddressBtn.tag = self.ArrayOfAddresses[indexPath.row].getID()//Replace with id
        cell.deleteAddressBtn.addTarget(self, action: #selector(deleteAddress), for: .touchUpInside)
        cell.deleteAddressBtn.indexPath = indexPath
        cell.editAddressBtn.tag = indexPath.row
        cell.detailsAddressBtn.tag = indexPath.row
        
        return cell
    }
    fileprivate var CellExpanded: Bool = false
    fileprivate var selectedIndexPath = 0
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
            if CellExpanded {
                CellExpanded = false
            } else {
                CellExpanded = true
            }
            AddressTableView.beginUpdates()
            AddressTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        CellExpanded = false
        AddressTableView.beginUpdates()
        AddressTableView.endUpdates()
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndexPath {
            if CellExpanded {
                return 120
            }
        }
        return 50
    }
    
     func deleteAddress(_ sender: ButtonWithIndexPath) {
        let alertController = UIAlertController(title: "Are you sure you want to delete this address?", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "DELETE", style: .destructive){
            UIAlertAction in
            var sessionTokenFromServer = String()
            self.view.makeToastActivity(.center)
            if preferences.object(forKey: "sessiontokenkey") != nil {
                if let sessiontoken :String = preferences.object(forKey: "sessiontokenkey") as? String{
                    sessionTokenFromServer = sessiontoken
                }
            }
            let urlForDeletingAddress = "\(URLs.putAddressURL)\(sender.tag)?token=\(sessionTokenFromServer)"
            Alamofire.request(urlForDeletingAddress, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
                response in
                let result = response.result
                if (result.value as? JSONStandard) != nil{
                    self.ArrayOfAddresses.remove(at: sender.indexPath.row)
                    
                    let incrementedIndexPath = NSIndexPath(row: sender.indexPath.row+1, section: sender.indexPath.section) as IndexPath
                    let cell1 = self.AddressTableView.cellForRow(at: incrementedIndexPath) as? AddressTableViewCellViewController
                    if cell1 != nil {
                        cell1?.editAddressBtn.tag = sender.indexPath.row
                        cell1?.detailsAddressBtn.tag = sender.indexPath.row
                        cell1?.deleteAddressBtn.tag = self.ArrayOfAddresses[sender.indexPath.row].getID()
                    }
                    self.AddressTableView.deleteRows(at: [sender.indexPath], with: .fade)
                    self.view.hideToastActivity()
                }
            })
        }
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        self.AddressTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoEditView"
        {
            let destinationViewController = segue.destination as? EditAddressViewController
            address = ArrayOfAddresses[(sender as! UIButton).tag]
            destinationViewController?.addressDetails.setID(address.getID())
            destinationViewController?.addressDetails.setuserid(address.getuserid())
            destinationViewController?.addressDetails.settitle(address.gettitle())
            destinationViewController?.addressDetails.setline1(address.getline1())
            destinationViewController?.addressDetails.setline2(address.getline2())
            destinationViewController?.addressDetails.setline3(address.getline3())
            //destinationViewController?.addressDetails.setpostcode(postcode: address.getpostcode())
            destinationViewController?.addressDetails.setcity(address.getcity())
            destinationViewController?.addressDetails.setcountry(address.getcountry())
            destinationViewController?.addressDetails.setgeolat(address.getgeolat())
            destinationViewController?.addressDetails.setgeolon(address.getgeolon())
            destinationViewController?.addressDetails.setnotes(address.getnotes())
        }
        if segue.identifier == "gotoDetailsView"
        {
            let destinationViewController = segue.destination as? DetailAddressViewController
            address = ArrayOfAddresses[(sender as! UIButton).tag]
            destinationViewController?.addressDetails.setID(address.getID())
            destinationViewController?.addressDetails.setuserid(address.getuserid())
            destinationViewController?.addressDetails.settitle(address.gettitle())
            destinationViewController?.addressDetails.setline1(address.getline1())
            destinationViewController?.addressDetails.setline2(address.getline2())
            destinationViewController?.addressDetails.setline3(address.getline3())
            //destinationViewController?.addressDetails.setpostcode(postcode: address.getpostcode())
            destinationViewController?.addressDetails.setcity(address.getcity())
            destinationViewController?.addressDetails.setcountry(address.getcountry())
            destinationViewController?.addressDetails.setgeolat(address.getgeolat())
            destinationViewController?.addressDetails.setgeolon(address.getgeolon())
            destinationViewController?.addressDetails.setnotes(address.getnotes())
        }
    }
}
