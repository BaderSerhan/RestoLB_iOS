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

eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjI5LCJpc3MiOiJodHRwczpcL1wvbWFycm91Y2gubXlhZGdhdGUuY29tXC9hcGlcL2F1dGhlbnRpY2F0ZSIsImlhdCI6MTUwNDg1ODQzOSwiZXhwIjoxNTA2MDY4MDM5LCJuYmYiOjE1MDQ4NTg0MzksImp0aSI6IjQzZGUwZGZhMmQ1ZmEwYjIwNmQyZTI1ZGRmMjE1NWY0In0.lwjpWYNfy1t_Gr-Zi_IGiDyfPEEIZ53ZP1SItgaDpiM
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
