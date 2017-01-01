//
//  Location.swift
//  Weather
//
//  Created by OMER BUKTE on 1/1/17.
//  Copyright © 2017 Omer Bukte. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
    
}
