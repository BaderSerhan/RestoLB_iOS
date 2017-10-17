//
//  boarderedView.swift
//  MRCH
//
//  Created by mrn on 5/16/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit

@IBDesignable class BorderedView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var border : CGFloat = 1
    @IBInspectable var borderColor : UIColor = colors.RestoDefaultColor
    
    override func layoutSubviews() {
        layer.borderWidth = border
        layer.borderColor = borderColor.cgColor
    }

}
