//
//  ButtonWithID.swift
//  MRCH
//
//  Created by mrn on 5/17/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit

@IBDesignable class ButtonWithID: UIButton {
    
    var itemID :Int = 0
    var index : Int = 0
    var name : String = ""
    
    var j = 0
    
    @IBInspectable var cornerRadius :CGFloat = 0
    
    //from Order Model
    var categoryID = 0
    var categoryName = ""
    var foodID = 0
    var foodName = ""
    var foodDescription:String? = ""
    var foodPrice = ""
    var foodImageURL = ""
    var foodImageData: Data? = Data()
    var itemNote:String? = ""
    
    //var options = [String: Any]()
    
    var optionsOrder : [Any] = []
    
    var quantity = 0
    
    var subPrice = 0
}
