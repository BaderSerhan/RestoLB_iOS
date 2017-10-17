//
//  OrderOption.swift
//  MRCH
//
//  Created by mrn on 5/16/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit

class FoodOption {
    var food_option_id : Int = 0
    var name : String = ""
    var types : [FoodOptionType] = []
    
    init(){}
    init(id: Int, name: String){
        //, types: [FoodOptionType]){
        self.food_option_id = id
        self.name = name
        //self.types = types
    }
    
    func printElements(){
        print(" Food Option_ID is: \(self.food_option_id)")
        print(" Food Option_Name is: \(self.name)")
        
    }
}
