//
//  MainVCExtension.swift
//  WowWeather
//
//  Created by asd dsa on 10/23/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let threeHoursForecast = threeHoursForecast else { return 0 }
        return (threeHoursForecast.list?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThreeHoursCastCellID",
                                                      for: indexPath) as! ThreeHoursForecastCell
        
        let forecast = threeHoursForecast.list![indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = dateFormatter.date(from: forecast.dtTxt)
        
        cell.timeLabel.text = date?.toString(dateFormat: "HH:mm")
        cell.temperatureLabel.text = String(Int(forecast.main.temp)) + "°"
        cell.weatherImageView.image = UIImage(named: forecast.weather[0].icon)
        cell.humidityLabel.text = String(forecast.main.humidity) + "%"
        
        return cell
    }
}
