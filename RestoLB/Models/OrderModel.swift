//
//  OrderModel.swift
//  MRCH
//
//  Created by MacBook on 8/2/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import Foundation
import UIKit

let preferences = UserDefaults.standard
//let backgroundView = UIImageView(image: #imageLiteral(resourceName: "TILE marrouche 2"))
/* sessiontoken:

eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM3LCJpc3MiOiJodHRwOlwvXC9yZXN0by5teWFkZ2F0ZS5jb21cL2FwaVwvYXV0aGVudGljYXRlIiwiaWF0IjoxNTA4MjUwMTQ2LCJleHAiOjE1MDk0NTk3NDYsIm5iZiI6MTUwODI1MDE0NiwianRpIjoiZTY1Mjk2YTdlNmUxOWQzZmE0YjEyNWY5NmVmYzM3ZjYifQ.CM9AUf6MyhvGl4GXNMwLXyefGvPv_sJ9loyyvVMZgls
*/

/* preferences include:
 "TotalQuantity"
 "CurrentOrder"
 "TotalPrice"
 
 sessiontokenkey
 facebooknamekey
 facebookemailkey
 facebookmobilekey
 useridkey
 
 CurrentLatitude
 CurrentLongitude
 
 isLoggedIn
 
 device_token
 
 */


class OrderModel: NSObject, NSCoding {
    
    var allItems : [Any] = []
    /*allItems contain:
     quantity
     categoryID
     categoryName
     
     FoodItem
     
     subPrice
     
     FoodOption
     */
    var quantity = 0
    var categoryID = 0
    var categoryName = ""
    var chosenFoodItem = FoodItem()
    /*
     var foodID = 0
     var foodName = ""
     var foodDescription = ""
     var foodPrice = ""
     */
    var subPrice = 0
    
    var optionsOfChosenFoodItem = [FoodOption()]
    /*
     var optionID = 0
     var optionName = ""
     */
    
    var typeOfChosenOption = FoodOptionType()
    /*
     var typeID = 0
     var typeName = ""
     */
    
    override init() {
    super.init()
    }
    
    func encode(with _aCoder: NSCoder) {
        _aCoder.encode(self.quantity, forKey: "Qty")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.quantity = Int(aDecoder.decodeInt32(forKey: "Qty"))
    
    }
}
