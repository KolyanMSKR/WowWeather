//
//  WeatherResponse.swift
//  WowWeather
//
//  Created by asd dsa on 10/23/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import Foundation

struct WeatherResponse: Codable {
    let message: Double?
    let list: [List]?
    let city: City?    
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: MainClass?
    let wind: Wind?
    let clouds: Clouds?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
}

struct City: Codable {
    let name: String
    let coord: Coord
    let country: String
    let timezone, sunrise, sunset: Int
}

struct Coord: Codable {
    let lat, lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

struct List: Codable {
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain?
    let sys: Sys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case main, weather, clouds, wind, rain, sys
        case dtTxt = "dt_txt"
    }
}

struct Clouds: Codable {
    let all: Int
}

struct MainClass: Codable {
    let temp, pressure: Double
    let tempMin, tempMax: Double?
    let humidity: Int
    let tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Rain: Codable {
    let the3H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct Sys: Codable {
    let pod: Pod?
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

struct Weather: Codable {
    let main: MainEnum
    let weatherDescription, icon: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
        case icon
    }
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case mist = "Mist"
    case fog = "Fog"
    case snow = "Snow"
    case drizzle = "Drizzle"
    case haze = "Haze"
    case smoke = "Smoke"
    case thunderstorm = "Thunderstorm"
    case dust = "Dust"
    case sand = "Sand"
    case ash = "Ash"
    case squall = "Squall"
    case tornado = "Tornado"
}

struct Wind: Codable {
    let speed, deg: Double?
}
