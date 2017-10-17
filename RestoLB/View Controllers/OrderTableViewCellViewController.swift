//
//  OrderTableViewCellViewController.swift
//  MRCH
//
//  Created by Eiiit on 7/26/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Cosmos

class OrderTableViewCellViewController: UITableViewCell {

    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var contains: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var rating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.addBackground()
        status.layer.masksToBounds = true
        status.layer.cornerRadius = 5.0
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
