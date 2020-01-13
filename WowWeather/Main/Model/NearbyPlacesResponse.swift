//
//  NearbyPlacesResponse.swift
//  WowWeather
//
//  Created by asd dsa on 11/21/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import Foundation

struct NearbyPlaces: Codable {
    let results: [Result]
}

struct Result: Codable {
    let placeID: String
    
    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
    }
}
