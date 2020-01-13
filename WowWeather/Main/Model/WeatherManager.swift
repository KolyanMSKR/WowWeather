//
//  WeatherManager.swift
//  WowWeather
//
//  Created by asd dsa on 10/23/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import Foundation

enum ForecastType {
    
    case CurrentWeather(apiKey: String, coordinates: Coord)
    case FiveDayThreeHourForecast(apiKey: String, coordinates: Coord)
    
    private var baseUrl: URL? {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/")
        return url!
    }
    
    private var endPoint: String {
        switch self {
        case .CurrentWeather(let apiKey, let coordinates):
            return "weather?units=metric&lat=\(coordinates.lat)&lon=\(coordinates.lon)&\(apiKey)"
        case .FiveDayThreeHourForecast(let apiKey, let coordinates):
            return "forecast?units=metric&lat=\(coordinates.lat)&lon=\(coordinates.lon)&\(apiKey)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: endPoint, relativeTo: baseUrl)
        return URLRequest(url: url!)
    }
    
}

class WeatherManager {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchCurrentWeatherWith(coordinates: Coord, completion: @escaping (WeatherResponse) -> Void) {
        let request = ForecastType.CurrentWeather(apiKey: "&APPID=a593cb213cae3edd2f3454a6c01d8e9d", coordinates: coordinates).request
        
        networkService.fetchJSONData(request: request, modelType: WeatherResponse.self) { currentWeather in
            completion(currentWeather!)
        }
    }
    
    func fetchFiveDayThreeHourForecastWith(coordinates: Coord, completion: @escaping (WeatherResponse) -> Void) {
        let request = ForecastType.FiveDayThreeHourForecast(apiKey: "&APPID=a593cb213cae3edd2f3454a6c01d8e9d", coordinates: coordinates).request
        
        networkService.fetchJSONData(request: request, modelType: WeatherResponse.self) { fiveDayThreeHourForecast in
            completion(fiveDayThreeHourForecast!)
        }
    }
    
}
