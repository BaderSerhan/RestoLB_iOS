//
//  FoodItemCollectionViewCell.swift
//  MRCH
//
//  Created by mrn on 3/10/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit

class FoodItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var trayButton: ButtonWithID!
    @IBOutlet weak var optionsView: UIStackView!
    
    override func prepareForReuse() {
        itemDescription.text = ""
        itemName.text = ""
        itemPrice.text = ""
        //itemImage.image = UIImage()
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        //self.addBackground()
        backView.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.8)
    }
}
