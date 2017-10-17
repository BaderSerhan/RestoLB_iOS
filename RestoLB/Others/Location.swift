//
//  City.swift
//  MRCH
//
//  Created by MacBook on 8/29/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import Foundation
import CoreLocation

struct locStruct {
    var name = ""
    var lat = 0.0
    var long = 0.0
    
    var location: CLLocation {
        return CLLocation(latitude: self.lat, longitude: self.long)
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}
