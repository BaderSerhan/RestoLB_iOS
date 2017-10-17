//
//  AddressTableViewCellViewController.swift
//  MRCH
//
//  Created by Eiiit on 7/24/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
//import AEAccordion

class AddressTableViewCellViewController: UITableViewCell {


    @IBOutlet weak var editAddressBtn: UIButton!
    @IBOutlet weak var Column1: UILabel!
    @IBOutlet weak var deleteAddressBtn: ButtonWithIndexPath!
    @IBOutlet weak var detailsAddressBtn: UIButton!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
    }
}
