
//
//  TrayViewController.swift
//  MRCH
//
//  Created by mrn on 5/17/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit

class TrayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    @IBOutlet weak var trayButton: UIBarButtonItem!
    let button = UIButton(type: .system)
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var arrayOfItems = [[String:Any]]()
    
    var totalPrice = 0
    var deliveryfee = 0
    var total = 0
    var totalusd: Double = 0
    
    var quantity = 0
    
    var isLoggedIn = preferences.bool(forKey: "isLoggedIn")
    
    @IBOutlet weak var trayCell: UICollectionView!
    
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var totalLL: UILabel!
    @IBOutlet weak var totalUSD: UILabel!
    
    @IBAction func plus(_ sender: UIButton) {
        let cell = trayCell.cellForItem(at: .init(row:sender.tag, section: 0)) as! TrayItemCollectionViewCell
        cell.currentQuantity += 1
        quantity += 1
        preferences.set(quantity, forKey: "TotalQuantity")
        button.setTitle("\(quantity)", for: .normal)
        
        cell.trayItemQuantity.text = String(describing: cell.currentQuantity)
        arrayOfItems[sender.tag]["quantity"] = cell.currentQuantity
        preferences.set(arrayOfItems, forKey: "CurrentOrder")
        
        cell.totalItemIntPrice = cell.currentQuantity*cell.trayItemIntPrice
        cell.totalItemPrice.text = String(cell.totalItemIntPrice)
        totalPrice += cell.trayItemIntPrice
        subtotal.text = "\(String(totalPrice)) L.L."
        preferences.set(totalPrice, forKey: "TotalPrice")
        
        deliveryfee = putDeliveryFee(totalPrice)
        deliveryFee.text = "\(String(deliveryfee)) L.L."
        total = totalPrice + deliveryfee
        totalLL.text = "\(String(total)) L.L."
        totalusd = Double(total)/1500
        totalUSD.text = "\(String(format: "%.2f", totalusd)) $"
    }
    
    @IBAction func minus(_ sender: UIButton) {
        let cell = trayCell.cellForItem(at: .init(row:sender.tag, section: 0)) as! TrayItemCollectionViewCell
        if cell.currentQuantity > 1 {
            cell.currentQuantity -= 1
            quantity -= 1
            preferences.set(quantity, forKey: "TotalQuantity")
            button.setTitle("\(quantity)", for: .normal)
            
            cell.trayItemQuantity.text = String(describing: cell.currentQuantity)
            arrayOfItems[sender.tag]["quantity"] = cell.currentQuantity
            preferences.set(arrayOfItems, forKey: "CurrentOrder")
            
            cell.totalItemIntPrice = cell.currentQuantity*cell.trayItemIntPrice
            cell.totalItemPrice.text = String(cell.totalItemIntPrice)
            totalPrice -= cell.trayItemIntPrice
            subtotal.text = "\(String(totalPrice)) L.L."
            preferences.set(totalPrice, forKey: "TotalPrice")
            
            deliveryfee = putDeliveryFee(totalPrice)
            deliveryFee.text = "\(String(deliveryfee)) L.L."
            total = totalPrice + deliveryfee
            totalLL.text = "\(String(total)) L.L."
            totalusd = Double(total)/1500
            totalUSD.text = "\(String(format: "%.2f", totalusd)) $"
        }
    }
    
 func putDeliveryFee (_ subtotal : Int) -> Int {
        if subtotal >= 20000 {
            return 0
        }
        else {
            return 1000
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.delegate = self
        
        isLoggedIn = preferences.bool(forKey: "isLoggedIn")
        if isLoggedIn == false {
            self.continueButton.setTitle("LOG IN TO CONTINUE", for: .normal)
            self.continueButton.addTarget(self, action: #selector(openSideMenu), for: .touchUpInside)
        } else{
            self.continueButton.setTitle("CONTINUE", for: .normal)
            self.continueButton.removeTarget(self, action: #selector(openSideMenu), for: .touchUpInside)
        }

        totalPrice = preferences.integer(forKey: "TotalPrice")
        subtotal.text = "\(String(totalPrice)) L.L."
        
            quantity = preferences.integer(forKey: "TotalQuantity")
            button.setTitle("\(quantity)", for: .normal)
            
            deliveryfee = putDeliveryFee(totalPrice)
            deliveryFee.text = "\(String(deliveryfee)) L.L."
            total = totalPrice + deliveryfee
            totalLL.text = "\(String(total)) L.L."
            totalusd = Double(total)/1500
            totalUSD.text = "\(String(format: "%.2f", totalusd)) $"
        
        if preferences.array(forKey: "CurrentOrder") != nil {
            self.arrayOfItems = preferences.array(forKey: "CurrentOrder") as! [[String : Any]]
        }
        trayCell.reloadData()
    }
    
     func openSideMenu(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "sideMenu")
        self.present(vc, animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //trayCell.backgroundView = backgroundView
        //self.view.addBackground()
        
        button.setBackgroundImage(#imageLiteral(resourceName: "oval"), for: .normal)
        button.setTitle("0", for: .normal)
        button.setTitleColor(colors.RestoDefaultColor, for: .normal)
        button.sizeToFit()
        self.trayButton.customView = button
    
        self.clearButton.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.clearButton.layer.borderWidth = 1.0
        self.clearButton.layer.cornerRadius = 5.0
        
        self.continueButton.layer.cornerRadius = 5.0
        
        if preferences.array(forKey: "CurrentOrder") != nil {
            self.arrayOfItems = preferences.array(forKey: "CurrentOrder") as! [[String : Any]]
        }
        
//        totalPrice = preferences.integer(forKey: "TotalPrice")
//        subtotal.text = "\(String(totalPrice)) L.L."

        trayCell.reloadData()
        
        //print("in tray \(self.arrayOfItems)")
        
        fromOrder = false
        NotificationCenter.default.addObserver(self, selector: #selector(clearTray(_:)), name: NSNotification.Name(rawValue: "clearTray"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = trayCell.dequeueReusableCell(withReuseIdentifier: "trayCell", for: indexPath) as! TrayItemCollectionViewCell
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 8.0
        
        cell.trayItemName.text = arrayOfItems[indexPath.row]["foodName"] as? String
        cell.noteLabel.text = arrayOfItems[indexPath.row]["itemNote"] as? String
        cell.plusBTN.tag = indexPath.row
        cell.minusBTN.tag = indexPath.row
        cell.clearItem.tag = indexPath.row
        cell.clearItem.indexPath = indexPath
        
        for view in cell.optionsView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
            if let arrayOfOptions = arrayOfItems[indexPath.row]["options"] as? NSArray{
                if(arrayOfOptions.count != 0){
                    for i in 0..<arrayOfOptions.count {
                        var optDic = arrayOfOptions[i] as! [String:Any]
                        let typeName = optDic["typeName"] as! String
                        let label = UILabel()
                        label.textColor = colors.RestoDefaultColor
                        label.text = typeName
                        cell.optionsView.addArrangedSubview(label)
                    }
                }
            }
        
            var priceDouble = 0.0
        
            if let price = arrayOfItems[indexPath.row]["foodPrice"] as? String {
                priceDouble = Double(price)!
                cell.trayItemIntPrice = Int(priceDouble)
                cell.trayItemPrice.text = "\(String(cell.trayItemIntPrice)) L.L."
            }
        
            if let quantity = arrayOfItems[indexPath.row]["quantity"] as? Int{
                cell.currentQuantity = quantity
                cell.trayItemQuantity.text = String(describing: quantity)
                cell.totalItemIntPrice = cell.trayItemIntPrice*quantity
                cell.totalItemPrice.text = "\(String(cell.totalItemIntPrice)) L.L."
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width;
        let cellWidth = screenWidth / 1.1;
        let screenHeight = screenRect.size.height
        let cellHeight = screenHeight / 5.0
        let size = CGSize(width: cellWidth, height: cellHeight)
        
        return size
    }
    
    @IBAction func clearTray(_ sender: Any) {
        if fromOrder == true{
            self.arrayOfItems.removeAll()
            preferences.removeObject(forKey: "TotalQuantity")
            preferences.removeObject(forKey: "CurrentOrder")
            preferences.removeObject(forKey: "TotalPrice")
            self.subtotal.text = "0 L.L."
            self.deliveryFee.text = "1000 L.L."
            self.totalLL.text = "1000 L.L."
            self.totalUSD.text = "0.67 $"
            self.button.setTitle("0", for: .normal)
            self.trayCell.reloadData()
        }else{
        if button.currentTitle != "0"{
            let alertController = UIAlertController(title: "Are you sure you want to clear all items in tray?", message: nil, preferredStyle: .alert)
            let clear = UIAlertAction(title: "CLEAR", style: .destructive){
                UIAlertAction in
                self.arrayOfItems.removeAll()
                preferences.removeObject(forKey: "TotalQuantity")
                preferences.removeObject(forKey: "CurrentOrder")
                preferences.removeObject(forKey: "TotalPrice")
                self.subtotal.text = "0 L.L."
                self.deliveryFee.text = "1000 L.L."
                self.totalLL.text = "1000 L.L."
                self.totalUSD.text = "0.67 $"
                self.button.setTitle("0", for: .normal)
                self.trayCell.reloadData()
            }
            let cancel = UIAlertAction(title: "CANCEL", style: .cancel)
            alertController.addAction(clear)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
            }
        else{
            let alertController = UIAlertController(title: "Tray is already empty.", message: nil, preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "Dismiss", style: .cancel)
            alertController.addAction(dismiss)
            self.present(alertController, animated: true, completion: nil)
        }
        }
    }
    
    @IBAction func clearItem(_ sender: ButtonWithIndexPath) {
        let cell = trayCell.cellForItem(at: .init(row:sender.tag, section: 0)) as! TrayItemCollectionViewCell
        
        arrayOfItems.remove(at: sender.indexPath.item)
        preferences.set(arrayOfItems, forKey: "CurrentOrder")
        
        quantity -= cell.currentQuantity
        preferences.set(quantity, forKey: "TotalQuantity")
        button.setTitle("\(quantity)", for: .normal)
        
        totalPrice -= cell.totalItemIntPrice
        //totalPrice -= Int(cell.totalItemPrice.text!)!
        subtotal.text = "\(String(totalPrice)) L.L."
        preferences.set(totalPrice, forKey: "TotalPrice")
        
        deliveryfee = putDeliveryFee(totalPrice)
        deliveryFee.text = "\(String(deliveryfee)) L.L."
        total = totalPrice + deliveryfee
        totalLL.text = "\(String(total)) L.L."
        totalusd = Double(total)/1500
        totalUSD.text = "\(String(format: "%.2f", totalusd)) $"
        
        let cell1 = trayCell.cellForItem(at: .init(row:sender.tag+1, section: 0)) as? TrayItemCollectionViewCell
        if cell1 != nil {
            cell1?.clearItem.tag = sender.tag
            cell1?.plusBTN.tag = sender.tag
            cell1?.minusBTN.tag = sender.tag
            cell1?.clearItem.indexPath = IndexPath(row: sender.tag, section: 0)
        }
        
        self.trayCell.deleteItems(at: [sender.indexPath])
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        var bool = true
        if identifier == "gotoMakeOrder"{
            if isLoggedIn == false {
                bool = false
            }
        }
        return bool
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoMakeOrder"{
            if preferences.string(forKey: "facebookmobilekey") == nil {
                let alertController = UIAlertController(title: "Mobile is Required.", message: "Please enter your mobile number in your Profile.", preferredStyle: .alert)
                let alert = UIAlertAction(title: "Go To Profile", style: .default){
                    UIAlertAction in
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "profileView")
                    self.navigationController!.pushViewController(vc, animated: true)
                }
                alertController.addAction(alert)
                self.present(alertController, animated: true, completion: nil)
            }
            
            if button.currentTitle == "0"{
                let alertController = UIAlertController(title: "Tray is Empty.", message: "Please select items from menu to make your order.", preferredStyle: .alert)
                let alert = UIAlertAction(title: "Go To Menu", style: .default){
                    UIAlertAction in
                    self.navigationController!.popToRootViewController(animated: true)
                }
                alertController.addAction(alert)
                self.present(alertController, animated: true, completion: nil)
            }
            
            
        }
    }
}
