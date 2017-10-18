
//
//  FoodItemsViewController.swift
//  MRCH
//
//  Created by mrn on 3/9/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation
import Toast_Swift

class FoodItemsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var selectedCategory :String = ""
    var selectedCategoryID: String = ""
    var url :String = ""
    
    var arrFCB : NSArray = NSArray()
    
    var foodItems = [FoodItem]()
    
    var foodOptions = [FoodOption]()
    
    var foodTypes = [FoodOptionType]()
    
    var arrayOfOptions = [[FoodOption]]()
    
    var numberOfOptions = [Int]()
    
    var optionButtonTitle:String = ""
    
    var pressedButtonID = 0
    var pressedButtonItemID = 0
    var pressedButtonName = ""
    var selectedTypeID = 0
    
    var quantity = 0
    var currentQuantity = 0
    
    var index = 0
    
    var j = 0
    
    var TotalPrice = 0
    
    var itemNote:String? = ""
    
    fileprivate let order = OrderModel()

    @IBOutlet weak var foodItemCell: UICollectionView!
    
    @IBOutlet weak var TrayButton: UIBarButtonItem!
    let button = UIButton(type: .system)
    
    var tray : TrayViewController!
    
    func gotoTrayButton(_ sender: UIBarButtonItem) {
        
        if tray == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            tray = storyboard.instantiateViewController(withIdentifier: "trayView") as! TrayViewController
        }
        
        self.navigationController!.pushViewController(tray, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        foodItemCell.backgroundView = backgroundView
        self.navigationItem.title = selectedCategory
        self.view.makeToastActivity(.center)
        getFoodItems()
        navigationController?.delegate = self
        
        button.setBackgroundImage(#imageLiteral(resourceName: "oval"), for: .normal)
        button.setTitle("0", for: .normal)
        button.setTitleColor(colors.RestoDefaultColor, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(gotoTrayButton(_:)), for: UIControlEvents.touchUpInside)
        self.TrayButton.customView = button
        
        quantity = preferences.integer(forKey: "TotalQuantity")
        TotalPrice = preferences.integer(forKey: "TotalPrice")
        
        if preferences.array(forKey: "CurrentOrder") != nil {
            order.allItems = preferences.array(forKey: "CurrentOrder")!
        }
    
        button.setTitle("\(preferences.integer(forKey: "TotalQuantity"))", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        quantity = preferences.integer(forKey: "TotalQuantity")
        button.setTitle("\(quantity)", for: .normal)
        
        TotalPrice = preferences.integer(forKey: "TotalPrice")
        
        if preferences.array(forKey: "CurrentOrder") != nil {
            order.allItems = preferences.array(forKey: "CurrentOrder")!
        }else {
            order.allItems.removeAll()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItems.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    var optionButtons = [ButtonWithID]()
    var selectedFoodItem = FoodItem()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = foodItemCell.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodItemCollectionViewCell
        if self.foodItems[indexPath.row].imageData != nil {
            let url = URL(string: self.foodItems[indexPath.row].itemImage)
            cell.itemImage.kf.setImage(with: url) //= UIImage(data: self.foodItems[indexPath.row].imageData!)
        }
        cell.itemImage.image = self.foodItems[indexPath.row].imageUI
        
        cell.trayButton.layer.masksToBounds = true
        cell.trayButton.layer.cornerRadius = 5.0
        cell.trayButton.categoryID = Int(selectedCategoryID)!
        cell.trayButton.categoryName = selectedCategory
        cell.trayButton.index = indexPath.row
        if (self.foodItems[indexPath.row].description != nil){
            cell.trayButton.foodDescription = self.foodItems[indexPath.row].description
        }
        cell.trayButton.foodID = self.foodItems[indexPath.row].food_id
        cell.trayButton.foodImageURL = self.foodItems[indexPath.row].itemImage
        if (self.foodItems[indexPath.row].imageData != nil){
            cell.trayButton.foodImageData = self.foodItems[indexPath.row].imageData
        }
        cell.trayButton.foodName = self.foodItems[indexPath.row].name
        cell.trayButton.foodPrice = self.foodItems[indexPath.row].itemPrice
        
        cell.itemName.text = self.foodItems[indexPath.row].name
        
        let d = Double(self.foodItems[indexPath.row].itemPrice)
        let i = Int(d!)
        cell.itemPrice.text = String(i) + " L.L."
        
        if(self.foodItems[indexPath.row].description != nil){
            cell.itemDescription.text = self.foodItems[indexPath.row].description
        }
        cell.layer.shouldRasterize = true;
        cell.layer.rasterizationScale = UIScreen.main.scale;
        
        cell.trayButton.addTarget(self, action: #selector(addToTray(_:)), for: .touchUpInside)
        
        //TODO: INFLATE OPTIONS
        for view in cell.optionsView.arrangedSubviews {
            view.removeFromSuperview()
        }
        optionButtons = [ButtonWithID]()
                for k in 0..<self.numberOfOptions[indexPath.row]{
                    optionButtons += [ButtonWithID()]
                    optionButtonTitle = self.foodItems[indexPath.row].options[k].name
                    optionButtons[k].name = optionButtonTitle
                    optionButtons[k].setTitle(optionButtonTitle, for: UIControlState.normal)
                    optionButtons[k].setTitleColor(UIColor.white, for: UIControlState.normal)
                    optionButtons[k].titleLabel?.font = UIFont(name: "Helvetica", size: 13.0)
                    optionButtons[k].backgroundColor = colors.RestoDefaultColor
                    optionButtons[k].layer.cornerRadius = 2
                    optionButtons[k].clipsToBounds = true
                    optionButtons[k].tag = self.foodItems[indexPath.row].options[k].food_option_id
                    optionButtons[k].j = k+1
                    optionButtons[k].itemID = self.foodItems[indexPath.row].food_id
                    optionButtons[k].index = indexPath.row
                    optionButtons[k].addTarget(self, action: #selector(changeOption(_:)), for: UIControlEvents.touchUpInside)
                    cell.optionsView.addArrangedSubview(optionButtons[k])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width;
        let cellWidth = screenWidth / 1.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
        let size = CGSize(width: cellWidth, height: cellWidth)
        
        return size;
    }
    
    func getFoodItems(){
        url = "\(URLs.foodsURL)\(selectedCategoryID)&with=options.types"

    Alamofire.request(url).responseJSON{ response in
        DispatchQueue.global().async {
            if let jsonResponse = response.result.value {

                let parsedJSON = JSON(jsonResponse)

                //debugPrint("debug print \(parsedJSON["data"].object)")

                let mydata: NSArray = (parsedJSON["data"].object as? NSArray)!

                self.arrFCB = mydata

                var zfooditem = NSDictionary()
                var zoptions = NSArray()
                var zoptions_dic = NSDictionary()
                var ztypes = NSArray()
                var ztypes_dic = NSDictionary()

                var food_id = 0
                var food_name = ""
                var food_description:String? = ""
                var food_price = ""
                var food_image = ""

                var food_option_id = 0
                var food_option_name = ""

                var food_option_type_id = 0
                var food_option_type_name = ""

                self.foodItems = [FoodItem]()
                for i in 0..<self.arrFCB.count{

                    zfooditem = self.arrFCB[i] as! NSDictionary

                    food_id = zfooditem ["id"] as! NSInteger
                    food_name = (zfooditem ["name"] as! NSString) as String
                    food_description = (zfooditem["description"] as? NSString) as String?
                    food_price = (zfooditem ["price"] as! NSString) as String
                    food_image = (zfooditem ["image"] as! NSString) as String

                    self.foodItems += [FoodItem(id: food_id, name: food_name, description: food_description, price: food_price, image: food_image)]
                    //, options: self.foodOptions)]
                    //self.foodItems[i].printElements()
                    //print("Food Options are:")

                    zoptions = zfooditem ["options"] as! NSArray

                    self.numberOfOptions += [zoptions.count]
                    if self.numberOfOptions[i] == 0 {
                        //print("No Options")
                        self.foodOptions.removeAll()
                        self.foodTypes.removeAll()
                    } else{
                        self.foodOptions = [FoodOption]()
                        for j in 0..<self.numberOfOptions[i]{
                            zoptions_dic = zoptions[j] as! NSDictionary
                            ztypes = zoptions_dic ["types"] as! NSArray

                            food_option_id = zoptions_dic["id"] as! NSInteger
                            food_option_name = (zoptions_dic["name"] as! NSString) as String

                            self.foodOptions += [FoodOption(id: food_option_id, name: food_option_name)]
                                //, types: self.foodTypes)]
                            //self.foodOptions[j].printElements()

                            self.foodTypes = [FoodOptionType] ()
                            for k in 0..<ztypes.count{
                                ztypes_dic = ztypes[k] as! NSDictionary
                                food_option_type_id = ztypes_dic["id"]  as! Int
                                food_option_type_name = ztypes_dic["name"]  as! String
                                self.foodTypes += [FoodOptionType(id: food_option_id, type_id:food_option_type_id, name: food_option_type_name)]
                                //self.foodTypes[k].printElements()
                            }
                            self.foodOptions[j].types = self.foodTypes
                        }
                    }
                    self.foodItems[i].options = self.foodOptions
                }
            }
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                self.foodItemCell.reloadData()
            }
        }
    }

//        //static way
//        self.numberOfOptions = [3,0]
//        self.foodItems.append(FoodItem(id: 1, name: "Hamburger", description: "Double Beef Burger", price: "12000", image: #imageLiteral(resourceName: "image")))
//
//        self.foodOptions.append(FoodOption(id: 1, name: "Ketchup"))
//        self.foodOptions.append(FoodOption(id: 2, name: "Cheese"))
//        self.foodOptions.append(FoodOption(id: 3, name: "Tomatoes"))
//
//        self.foodTypes.append(FoodOptionType(id: 1, type_id: 1, name: "Extra Ketchup"))
//        self.foodTypes.append(FoodOptionType(id: 1, type_id: 2, name: "No Ketchup"))
//        self.foodTypes.append(FoodOptionType(id: 1, type_id: 3, name: "Moderate Ketchup"))
//
//        self.foodOptions[0].types = self.foodTypes
//        self.foodTypes.removeAll()
//
//        self.foodTypes.append(FoodOptionType(id: 1, type_id: 1, name: "Extra Cheese"))
//        self.foodTypes.append(FoodOptionType(id: 1, type_id: 2, name: "No Cheese"))
//        self.foodTypes.append(FoodOptionType(id: 1, type_id: 3, name: "Moderate Cheese"))
//
//        self.foodOptions[1].types = self.foodTypes
//        self.foodTypes.removeAll()
//
//        self.foodTypes.append(FoodOptionType(id: 1, type_id: 1, name: "Extra Tomatoes"))
//        self.foodTypes.append(FoodOptionType(id: 1, type_id: 2, name: "No Tomatoes"))
//        self.foodTypes.append(FoodOptionType(id: 1, type_id: 3, name: "Moderate Tomatoes"))
//
//        self.foodOptions[2].types = self.foodTypes
//        self.foodTypes.removeAll()
//
//        self.foodItems[0].options = self.foodOptions
//
//        self.foodOptions.removeAll()
//        self.foodItems.append(FoodItem(id: 2, name: "Cheese Burger", description: "With Mozarella", price: "10000", image: #imageLiteral(resourceName: "chicken-burger")))
//        self.foodItems[1].options = self.foodOptions
//        self.view.hideToastActivity()
//        self.foodItemCell.reloadData()
}
    @objc func changeOption(_ sender: UIButton) {
        performSegue(withIdentifier: "changeOption", sender: sender)
    }
    
    @objc func addToTray(_ sender: ButtonWithID){
        performSegue(withIdentifier: "addToTray", sender: sender) 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeOption"{
            let svc = segue.destination as! OptionsViewController
            pressedButtonID = (sender as! ButtonWithID).tag
            j = (sender as! ButtonWithID).j
            pressedButtonName = (sender as! ButtonWithID).name
            svc.currentOption = pressedButtonID
            pressedButtonItemID = (sender as! ButtonWithID).itemID
            svc.currentfoodItem = pressedButtonItemID
            svc.foodItems = self.foodItems
            self.index = (sender as! ButtonWithID).index
        }
        
        if segue.identifier == "addToTray"{
            self.index = (sender as! ButtonWithID).index
        }
    }
    var arrOfOptions : [Int] = []
    @IBAction func unwindBack(_ unwindSegue: UIStoryboardSegue){
        let cell = foodItemCell.cellForItem(at: .init(row: self.index, section: 0)) as! FoodItemCollectionViewCell
        
        if unwindSegue.identifier == "optionSelected" {
            let btn = cell.optionsView.subviews[j-1] as! ButtonWithID
            btn.setTitle(optionButtonTitle, for: .normal)
            
            arrOfOptions.append(pressedButtonID)
            let end = arrOfOptions.endIndex
            var found = false
            for i in 0..<end-1{
                if arrOfOptions[i] == pressedButtonID{
                    found = true
                    cell.trayButton.optionsOrder[i] = ["optionID": pressedButtonID, "optionName": pressedButtonName, "typeID": selectedTypeID, "typeName": optionButtonTitle]
                }
            }
            if !found{
                cell.trayButton.optionsOrder += [["optionID": pressedButtonID, "optionName": pressedButtonName, "typeID": selectedTypeID, "typeName": optionButtonTitle]]
            }
        }
        if unwindSegue.identifier == "backtoFood"{
            
            cell.trayButton.quantity = self.currentQuantity
            cell.trayButton.itemNote = self.itemNote
            preferences.set(quantity, forKey: "TotalQuantity")
            button.setTitle("\(quantity)", for: .normal)
            
            let priceDouble = Double(cell.trayButton.foodPrice)
            let priceInt = Int(priceDouble!)
            cell.trayButton.subPrice = self.currentQuantity*priceInt
            TotalPrice += cell.trayButton.subPrice
            
            preferences.set(TotalPrice, forKey: "TotalPrice")
            
            order.allItems += [["quantity": cell.trayButton.quantity,
                               "categoryID":cell.trayButton.categoryID,
                               "itemNote": cell.trayButton.itemNote ?? "",
                               //"categoryName":cell.trayButton.categoryName,
                                "foodID": cell.trayButton.foodID,
                                "foodName": cell.trayButton.foodName,
                                "foodDescription": cell.trayButton.foodDescription ?? "No Description",
                                "foodPrice": cell.trayButton.foodPrice,
                                "subPrice": cell.trayButton.subPrice,
                                "options": cell.trayButton.optionsOrder]]
            
            preferences.set(order.allItems, forKey: "CurrentOrder")
            
            preferences.synchronize()
            
            cell.trayButton.optionsOrder.removeAll()
            arrOfOptions.removeAll()
            
             for i in 0..<self.numberOfOptions[self.index]{
                let btn = cell.optionsView.arrangedSubviews[i] as! ButtonWithID
                btn.setTitle(self.foodItems[self.index].options[i].name, for: .normal)
            }
        }
    }
}
