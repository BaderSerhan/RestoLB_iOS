//
//  FoodItem.swift
//  MRCH
//
//  Created by mrn on 5/4/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import Foundation
import UIKit

class FoodItem {
    var food_id : Int = 0
    var name : String = ""
    var description : String? = ""
    var itemPrice : String = ""
    var itemImage : String = ""
    var imageData : Data? = Data ()
    var imageUI : UIImage = UIImage()
   // var itemCount : Int = 0
   // var itemNote : String = ""
    var options : [FoodOption] = []
    
    init(){}
    init(id: Int, name:String, description: String?, price:String, image: String){
        //, options: [FoodOption]){
        
        self.food_id = id
        self.name = name
        self.description = description
        self.itemPrice = price
        self.itemImage = image
        self.imageData = try? Data(contentsOf: URL(string: image)!)
    }
    
    init(id: Int, name:String, description: String?, price:String, image: UIImage){
        //, options: [FoodOption]){
        
        self.food_id = id
        self.name = name
        self.description = description
        self.itemPrice = price
//        self.itemImage = image
//        self.imageData = try? Data(contentsOf: URL(string: image)!)
        self.imageUI = image
    }
    
    func printElements (){
        print ("\n")
        print ("Food ID is: \(self.food_id)")
        print ("Food Name is: \(self.name)")
        print ("Description is: \(self.description ?? "no description")")
        print ("Food Price is: \(self.itemPrice)")
        print ("Food Image Path is: \(self.itemImage)")
        
        //print (self.options.count)
        
        //                    if(self.foodItems[i].options.count > 0){
        //                        print (self.foodItems[i].options)
        //                    }else{
        //                        print("no options")
        //                    }
    }
}
