//
//  IntExtension.swift
//  WowWeather
//
//  Created by asd dsa on 10/23/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import Foundation

extension Int {
    
    func windDirection() -> String {
        let halfRange = 360/8/2
        
        let directions = ["↘️", "⬇️", "↙️", "⬅️", "↖️", "⬆️", "↗️", "➡️"]
        let direction = Int(-halfRange + self) / 45
        
        return directions[direction]
    }
    
}
