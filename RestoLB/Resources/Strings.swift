//
//  Strings.swift
//  MRCH
//
//  Created by MacBook on 9/13/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import Foundation
import UIKit

struct URLs {
    
    static let foodsURL = "http://resto.myadgate.com/api/items?search=category_id:" //+categoryID + "&with=options.types"
    static let categoriesURL = "http://resto.myadgate.com/api/categories"
    static let addressURL = "http://resto.myadgate.com/api/addresses?token=" //+token
    static let putAddressURL = "http://resto.myadgate.com/api/addresses/" //+ID+token
    static let orderHistoryURL = "http://resto.myadgate.com/api/orders?with=items.item;items.options.type;address&token=" //+token
    static let orderURL = "http://resto.myadgate.com/api/orders?token=" //+token
    static let orderIDURL = "http://resto.myadgate.com/api/orders/" //+orderID
    static let authenticateAPIURL = "http://resto.myadgate.com/api/authenticate"
    static let usersURL = "http://resto.myadgate.com/api/users?search=facebook:" //+facebookID
    static let userIDURL = "http://resto.myadgate.com/api/users/" //+userID
    static let reviewURL = "http://resto.myadgate.com/api/review_questions"
    static let annURL = "http://resto.myadgate.com/api/announcements"
}

struct colors {
    static let RestoDefaultColor = UIColor(red: 52.0/255.0, green: 61.0/255.0, blue: 91.0/255.0, alpha: 1.0)
}
