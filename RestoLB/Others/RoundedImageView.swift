//
//  RoundedImage.swift
//  MRCH
//
//  Created by mrn on 5/17/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit

@IBDesignable class RoundedImageView: UIImageView {
    var radii : CGFloat? = nil
    override func layoutSubviews() {
        if radii == nil{
            layer.cornerRadius = frame.width/2
        }
        else {
            layer.cornerRadius = radii!
        }
        clipsToBounds = true
    }
    
}
