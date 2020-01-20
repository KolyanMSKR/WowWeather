//
//  FavoriteCityViewController.swift
//  WowWeather
//
//  Created by asd dsa on 11/9/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import UIKit

class FavoriteCityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let networkService = NetworkService()
    private var weatherManager: WeatherManager!
    private let dbManager = DBManager()
    
    var cities = [FavoriteCity]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override var preferredContentSize: CGSize {
        get {
            self.tableView.contentSize = CGSize(width: 250, height: cities.count * 44)
            return self.tableView.contentSize
        }
        set {}
    }
    
    // MARK: - Lifecycle's methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        cities = dbManager.fetchCities()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager = WeatherManager(networkService: networkService)
    }
    
}

extension FavoriteCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - UITableViewDataSource's methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCityCellID",
                                                 for: indexPath) as! FavoriteCityCell
        
        let latitude = cities[indexPath.row].latitude
        let longitude = cities[indexPath.row].longitude
        
        weatherManager.fetchCurrentWeatherWith(coordinates: Coord(lat: latitude, lon: longitude)) { currentWeather in
            cell.configureCell(currentWeather: currentWeather)
        }
        
        return cell
    }
    
    //MARK: - UITableViewDelegate's methods
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { rowAction, _ in
            self.dbManager.remove(city: self.cities[indexPath.row])
            self.cities.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        return [deleteAction]
    }
}
