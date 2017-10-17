//
//  OrderHistoryViewController.swift
//  MRCH
//
//  Created by Eiiit on 7/26/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Cosmos

class OrderHistoryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var orderTableView: UITableView!
    var myurl = String()
    
    //let myurl = "https://marrouch.myadgate.com/api/orders?with=items.item;items.options.type;address&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjMsImlzcyI6Imh0dHA6XC9cL21hcnJvdWNoLm15YWRnYXRlLmNvbVwvYXBpXC9hdXRoZW50aWNhdGUiLCJpYXQiOjE1MDEwNzE3MTAsImV4cCI6MTUwMjI4MTMxMCwibmJmIjoxNTAxMDcxNzEwLCJqdGkiOiI5MDJlYTM0Yzk0MjlhNjQ3MDgwODUwZTMwZTU3YjcyNCJ9.9o9kxI1dFjpN-JbQQg-AC1G09iyDWcW4N2LLOJPLw5A"
    
    //typealias JSONStandard = Dictionary<String, AnyObject>
    
    var ArrayOfOrders =  [FoodOrder]()
    
    var name = ""
    var orderNo: [Int] = []
    var price: [String] = []
    var address: [String] = []
    var count : [Int] = []
    var names : [[String]] = []
    var stage : [String] = []
    var rating : [Int] = []
    
    var arrayOfItems = [[String : Any]]()
    
    @IBAction func gotoTray(_ sender: UIBarButtonItem) {
        var tray : TrayViewController!
        if tray == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            tray = storyboard.instantiateViewController(withIdentifier: "trayView") as! TrayViewController
        }
        if preferences.array(forKey: "CurrentOrder") != nil {
            tray.arrayOfItems = preferences.array(forKey: "CurrentOrder") as! [[String : Any]]
        }
        self.navigationController!.pushViewController(tray, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.makeToastActivity(.center)
        
        self.orderTableView.delegate = self
        self.orderTableView.dataSource = self
        
        orderTableView.bounds = CGRect (x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.bounds.width-10, height: self.view.bounds.height-10)
        
        let sessiontokenkey = "sessiontokenkey"
        if preferences.object(forKey: sessiontokenkey) != nil {
            if let sessiontoken :String = preferences.object(forKey: sessiontokenkey) as? String{
                myurl = URLs.orderHistoryURL + sessiontoken
            }
        }
        Alamofire.request(myurl).responseJSON { response in
            if let jsonResponse = response.result.value {
                //print(jsonResponse)
                let parsedJSON = JSON(jsonResponse)
                let mydata: NSDictionary = (parsedJSON["data"].object as? NSDictionary)!
                if let myName = mydata["name"] as? String {
                    self.name = myName
                }
                
                let orderdata = mydata["orders"] as! [NSDictionary]
                
                for i in 0..<orderdata.count{
                    let tempOrder = FoodOrder()
                    tempOrder.address_id = orderdata[i]["address_id"] as? String ?? ""
                    tempOrder.created_at = orderdata[i]["created_at"] as? String ?? ""
                    tempOrder.delivery_notes = orderdata[i]["delivery_notes"] as? String ?? ""
                    
                    self.orderNo += [orderdata[i]["id"] as! Int]
                    //if orderdata[i]["total_price"] != nil {
                    self.price += [(orderdata[i]["total_price"] as? String ?? "")]
                    //}else{
                    //    self.price += [""]
                    //}
                    self.count += [orderdata[i]["items_count"] as! Int]
                    self.stage += [orderdata[i]["stage"] as! String]
                    self.rating += [orderdata[i]["score"] as! Int]
                    
                    let myaddress = orderdata[i]["address"] as? NSDictionary
                    self.address += [myaddress?["title"] as? String ?? ""]
                    
                    var foodNames : [String] = []
                    var foodOptions : [Any] = []
                    
                    if orderdata[i]["items"] != nil {
                        let myItems = orderdata[i]["items"] as! [NSDictionary]
                        for j in 0..<myItems.count{
                            let quantity = myItems[j]["quantity"] as! Int
                            let subPrice = myItems[j]["total_price"] as! String
                            
                            let myItem = myItems[j]["item"] as! NSDictionary
                            let categoryID = myItem["category_id"] as! Int
                            let foodID = myItem["id"] as! Int
                            let foodName = myItem["name"]as! String
                            foodNames.append(foodName)
                            let foodDescription = myItem["description"] as? String
                            let foodPrice = myItem["price"] as! String
                            
                            foodOptions.removeAll()
                            if let arrayOfOptions = myItems[j]["options"] as? NSArray{
                                if(arrayOfOptions.count != 0){
                                    for i in 0..<arrayOfOptions.count {
                                        var optDic = arrayOfOptions[i] as! [String:Any]
                                        let type = optDic["type"] as! NSDictionary
                                        
                                        let optID = type["option_id"] as! Int
                                        let optName = type["name"] as! String
                                        let typeID = type["id"] as! Int
                                        
                                        foodOptions += [["optionID": optID, "optionName": "", "typeID": typeID, "typeName": optName]]
                                        //print(foodOptions)
                                    }
                                }
                            }
                            
                            let dictionaryEntry =
                                ["quantity": quantity,
                                 "categoryID":categoryID,
                                 "foodID": foodID,
                                 "foodName": foodName,
                                 "foodDescription": foodDescription ?? "",
                                 "foodPrice": foodPrice,
                                 "subPrice": subPrice,
                                 "options": foodOptions,
                                 "orderNo": self.orderNo[i]] as [String : Any]
                            
                            self.arrayOfItems += [dictionaryEntry]
                        }
                    } else {
                        let dictionaryEntry =
                            ["quantity": 0,
                             "categoryID":0,
                             "foodID": 0,
                             "foodName": "",
                             "foodDescription": "" ,
                             "foodPrice": "",
                             "subPrice": "",
                             "options": foodOptions,
                             "orderNo": self.orderNo[i]] as [String : Any]
                        
                        self.arrayOfItems += [dictionaryEntry]
                        //foodOptions.removeAll()
                    }
                    self.names.append(foodNames)
                    self.ArrayOfOrders.append(tempOrder)
                }
                self.view.hideToastActivity()
                self.orderTableView.reloadData()
                
                if self.ArrayOfOrders.count == 0 {
                    let alertController = UIAlertController(title: "Order History is Empty.", message: "You don't have any orders yet. Make your first order now!", preferredStyle: .alert)
                    let alert = UIAlertAction(title: "Make Order", style: .default){
                        UIAlertAction in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    alertController.addAction(alert)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ArrayOfOrders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1// numberOfAddresses
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
     @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "gotoRating", sender: recognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoRating"{
            let orderNo = (sender as! UITapGestureRecognizer).view?.tag
            let ratingView = segue.destination as! RatingViewController
            ratingView.orderNum = orderNo!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderTableViewCellViewController = self.orderTableView.dequeueReusableCell(withIdentifier: "orderCell")! as! OrderTableViewCellViewController
        
        cell.orderNo.text = String(self.orderNo[indexPath.section])
        cell.date.text = self.ArrayOfOrders[indexPath.section].created_at
        cell.name.text = self.name
        cell.address.text = self.address[indexPath.section]
        cell.status.text = self.stage[indexPath.section]
        cell.rating.rating = Double(self.rating[indexPath.section])
        
        if cell.status.text == "Delivered"{
            let recognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))
            recognizer.numberOfTapsRequired = 1;
            cell.rating.addGestureRecognizer(recognizer)
            recognizer.view?.tag = self.orderNo[indexPath.section]
        }
       let count = self.count[indexPath.section]
        var text = "\(String(count)) ("
        text += names[indexPath.section][0]
        text += "...)"
        cell.contains.text = text
        cell.price.text = self.price[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tray = storyboard.instantiateViewController(withIdentifier: "trayView") as! TrayViewController
        
        var array = [[String : Any]]()
        var total = 0
        var quantity  = 0
        
        if preferences.array(forKey: "CurrentOrder") != nil {
            let alertController = UIAlertController(title: "Tray already has items.", message: "Do you want to add to your existing tray or empty it?", preferredStyle: .actionSheet)
            
            let empty = UIAlertAction(title: "EMPTY", style: .destructive)
            {
              UIAlertAction in
                
                for i in 0..<self.arrayOfItems.count{
                    if self.arrayOfItems[i]["orderNo"] as! Int == self.orderNo[indexPath.section] {
                        //must send arrayOfItems here
                        array += [self.arrayOfItems[i]]
                    }
                }
                if self.price[indexPath.section] == "" {
                    total += 0
                }else {
                    preferences.set(array, forKey: "CurrentOrder")
                    total += Int(Double(self.price[indexPath.section])!)
                    preferences.set(total, forKey: "TotalPrice")
                    quantity += self.count[indexPath.section]
                    preferences.set(quantity, forKey: "TotalQuantity")
                    preferences.synchronize()
                    
                }
                self.navigationController!.pushViewController(tray, animated: true)
            }
            let add = UIAlertAction(title: "ADD", style: .default)
            {
                UIAlertAction in
                array = preferences.array(forKey: "CurrentOrder") as! [[String : Any]]
                total = preferences.integer(forKey: "TotalPrice")
                quantity = preferences.integer(forKey: "TotalQuantity")
                
                for i in 0..<self.arrayOfItems.count{
                    if self.arrayOfItems[i]["orderNo"] as! Int == self.orderNo[indexPath.section] {
                        //must send arrayOfItems here
                        array += [self.arrayOfItems[i]]
                    }
                }
                
                preferences.set(array, forKey: "CurrentOrder")
                total += Int(Double(self.price[indexPath.section])!)
                preferences.set(total, forKey: "TotalPrice")
                quantity += self.count[indexPath.section]
                preferences.set(quantity, forKey: "TotalQuantity")
                preferences.synchronize()
                self.navigationController!.pushViewController(tray, animated: true)
            }
            alertController.addAction(empty)
            alertController.addAction(add)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
                (alertAction: UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            for i in 0..<self.arrayOfItems.count{
                if self.arrayOfItems[i]["orderNo"] as! Int == self.orderNo[indexPath.section] {
                    //must send arrayOfItems here
                    array += [self.arrayOfItems[i]]
                }
            }
            if self.price[indexPath.section] == "" {
                total += 0
            }else {
                preferences.set(array, forKey: "CurrentOrder")
                total += Int(Double(self.price[indexPath.section])!)
                preferences.set(total, forKey: "TotalPrice")
                quantity += self.count[indexPath.section]
                preferences.set(quantity, forKey: "TotalQuantity")
                preferences.synchronize()
            }
            
            self.navigationController!.pushViewController(tray, animated: true)
            
        }
        orderTableView.deselectRow(at: indexPath, animated: true)
    }
}
