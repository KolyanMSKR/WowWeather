//
//  FavoriteCity.swift
//  WowWeather
//
//  Created by asd dsa on 11/8/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteCity: Object {
    
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
