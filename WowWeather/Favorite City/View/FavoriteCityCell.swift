//
//  FavoriteCityCell.swift
//  WowWeather
//
//  Created by asd dsa on 11/12/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import UIKit

class FavoriteCityCell: UITableViewCell {

    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var sunStateImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configureCell(currentWeather: WeatherResponse) {
        nameCityLabel.text = currentWeather.name
        
        if let icon = currentWeather.weather?[0].icon {
            let iconImage = WeatherConditionIconManager(rawValue: icon)
            sunStateImageView.image = iconImage.image
        }
        if let temperature = currentWeather.main?.temp {
            temperatureLabel.text = String(format: "%.0f", temperature) + "°"
        }
    }
    
}
