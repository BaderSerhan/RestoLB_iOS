//
//  OrderOptionTypes.swift
//  MRCH
//
//  Created by mrn on 5/11/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import Foundation

class FoodOptionType : CustomStringConvertible{
    var food_option_id : Int = 0
    var food_option_type_id : Int = 0
    var name : String = ""
    
    
    init(){}
    init(id: Int, type_id: Int, name: String){
        self.food_option_id = id
        self.food_option_type_id = type_id
        self.name = name
    }
    
    func printElements(){
       // print("     Food Option_ID is: \(self.food_option_id)")
        print("     Food Option Type_ID is: \(self.food_option_type_id)")
        print("     Food Option Type Name is: \(self.name)")
    }
    
    var description: String {
        return "(\(food_option_id) ,\(food_option_type_id) ,\(name))"
    }
}
