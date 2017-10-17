//
//  TrayItemCollectionViewCell.swift
//  MRCH
//
//  Created by mrn on 5/17/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit

class TrayItemCollectionViewCell: UICollectionViewCell {
    
    //@IBOutlet weak var trayItemImage: RoundedImageView!
    @IBOutlet weak var trayItemName: UILabel!
    @IBOutlet weak var optionsView: UIStackView!
    @IBOutlet weak var trayItemQuantity: UILabel!
    @IBOutlet weak var trayItemPrice: UILabel!
    @IBOutlet weak var totalItemPrice: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var minusBTN: UIButton!
    @IBOutlet weak var plusBTN: UIButton!
    
    @IBOutlet weak var clearItem: ButtonWithIndexPath!
    
    var currentQuantity = 1
    var trayItemIntPrice = 0
    var totalItemIntPrice = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setNeedsDisplay()
        trayItemName.text = ""
        trayItemPrice.text = ""
        trayItemQuantity.text = ""
        totalItemPrice.text = ""
    }
    
//    override func awakeFromNib() {
//        self.addBackground()
//    }
}
