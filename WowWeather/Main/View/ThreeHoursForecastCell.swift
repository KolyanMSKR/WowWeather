//
//  ThreeHoursForecastCell.swift
//  WowWeather
//
//  Created by asd dsa on 10/23/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import UIKit

class ThreeHoursForecastCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    func configureCell(forecast: List) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = dateFormatter.date(from: forecast.dtTxt)
        
        timeLabel.text = date?.toString(dateFormat: "HH:mm")
        temperatureLabel.text = String(Int(forecast.main.temp)) + "°"
        weatherImageView.image = UIImage(named: forecast.weather[0].icon)
        humidityLabel.text = String(forecast.main.humidity) + "%"
    }
}
