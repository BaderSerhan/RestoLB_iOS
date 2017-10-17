//
//  SetOrderItemViewController.swift
//  MRCH
//
//  Created by mrn on 5/9/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit

class SetOrderItemViewController: UIViewController {

    @IBOutlet weak var quantitydisplay: UILabel!
    @IBOutlet weak var itemNote: UITextView!
    @IBOutlet weak var quantityView: BorderedView!
    @IBOutlet weak var imageView: UIImageView!
    
    var item_id :NSNumber = 0
    var itemOptions : [FoodOptionType] = []
    var itemPrice = 0
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var quantity = 1
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
        super.touchesBegan(touches, with: event)
    }
    
     func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addBackground()
        
        quantitydisplay.text = String(quantity)
        itemNote.textColor = UIColor.black
        itemNote.placeholder = "Enter your comment here..."
        
        itemNote.layer.cornerRadius = 5.0
        quantitydisplay.layer.cornerRadius = 5.0
        quantityView.layer.cornerRadius = 5.0
        imageView.layer.cornerRadius = 5.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.cancelBtn.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.cancelBtn.layer.borderWidth = 1.0
        self.cancelBtn.layer.cornerRadius = 5.0
        
        self.confirmBtn.layer.cornerRadius = 5.0
    }
    
    @IBAction func quantityDecrease(_ sender: Any) {
        if quantity > 1 {
            quantity -= 1
            quantitydisplay.text = String(quantity)
        }
    }
    
    @IBAction func quantityIncrease(_ sender: Any) {
        quantity += 1
        quantitydisplay.text = String(quantity)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveToTray(_ sender: Any) {
        performSegue(withIdentifier: "backtoFood", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backtoFood"{
            let svc = segue.destination as! FoodItemsViewController
            svc.itemNote = self.itemNote.text
            svc.currentQuantity = self.quantity
            svc.quantity += self.quantity
        }
    }
}
