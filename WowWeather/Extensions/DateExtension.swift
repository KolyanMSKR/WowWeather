//
//  DateExtension.swift
//  WowWeather
//
//  Created by asd dsa on 10/23/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self as Date)
    }
    
}
