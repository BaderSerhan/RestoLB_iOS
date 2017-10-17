//
//  OptionsViewController.swift
//  MRCH
//
//  Created by MacBook on 7/26/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import DLRadioButton

class OptionsViewController: UIViewController {

    @IBOutlet weak var optionsView: UIView!
    
    let radioButton = DLRadioButton.init()
    var radioGroup = [DLRadioButton] ()
    var radio = DLRadioButton()
    
    var selectedType = ""
    var foodItems = [FoodItem]()
    var currentfoodItem = 0
    var currentOption = 0
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        radioGroup.append(radioButton)
        let currentTypes = searchInFoodItems()
        for i in 0..<currentTypes.count{
            radio = DLRadioButton(frame: CGRect(x: 10, y: 50*i, width: 300, height: 60))
            radio.titleLabel?.numberOfLines = 0
            radio.setTitle(currentTypes[i].name, for: .normal)
            radio.tag = currentTypes[i].food_option_type_id
            radio.icon = #imageLiteral(resourceName: "unchecked")
            radio.iconSelected = #imageLiteral(resourceName: "checked")
            radio.isIconOnRight = false
            radio.isMultipleSelectionEnabled = false
            radio.setTitleColor(UIColor.black, for: UIControlState.normal)
            radio.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
            radio.addTarget(self, action: #selector(unwindBack(_:)), for: UIControlEvents.touchUpInside)
            optionsView.addSubview(radio)
            radioGroup.append(radio)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func searchInFoodItems() -> [FoodOptionType]{
        var currentTypes = [FoodOptionType]()
        for i in 0..<self.foodItems.count{
            if(self.currentfoodItem == self.foodItems[i].food_id){
                for j in 0..<self.foodItems[i].options.count{
                    if(self.currentOption == self.foodItems[i].options[j].food_option_id){
                        currentTypes = self.foodItems[i].options[j].types
                    }
                }
            }
        }
        return currentTypes
    }
    
     func unwindBack(_ sender: DLRadioButton) {
        performSegue(withIdentifier: "optionSelected", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "optionSelected"{
            let svc = segue.destination as! FoodItemsViewController
            selectedType = (sender as! DLRadioButton).currentTitle!
            svc.optionButtonTitle = selectedType
            svc.selectedTypeID = (sender as! DLRadioButton).tag
        }
    }
}
