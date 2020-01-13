//
//  AppDelegate.swift
//  WowWeather
//
//  Created by asd dsa on 10/23/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyAtUsFZoCXpk8MLCQGv7VHCADgxIzpMLls")
        GMSServices.provideAPIKey("AIzaSyAtUsFZoCXpk8MLCQGv7VHCADgxIzpMLls")
        
        return true
    }
    
}

