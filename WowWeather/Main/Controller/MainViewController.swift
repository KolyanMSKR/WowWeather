//
//  MainViewController.swift
//  WowWeather
//
//  Created by asd dsa on 10/23/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var threeHoursCollectionView: UICollectionView!
    @IBOutlet weak var topStackView: UIStackView!    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var sunStateImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placePhotoImageView: UIImageView!
    
    // MARK: - Constants & Variables
    var threeHoursForecast: WeatherResponse! {
        didSet {
            DispatchQueue.main.async {
                self.threeHoursCollectionView.reloadData()
            }
        }
    }
    
    private let networkService = NetworkService()
    private var weatherManager: WeatherManager!
    private let dbManager = DBManager()
    private let locationManager = CLLocationManager()
    private var placesClient: GMSPlacesClient!
    private var latitude: Double!
    private var longitude: Double!
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureLocationManager()
        configureMapView()
        
        weatherManager = WeatherManager(networkService: networkService)
        placesClient = GMSPlacesClient()
        
        getWeatherForCurrentLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Pop" {
            let destination = segue.destination
            if let popover = destination.popoverPresentationController {
                popover.delegate = self
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func searchCityAction(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!.rawValue | GMSPlaceField.coordinate.rawValue)!
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func currentLocationAction(_ sender: UIBarButtonItem) {
        getWeatherForCurrentLocation()
    }
    
    @IBAction func addCityToFavorite(_ sender: UIBarButtonItem) {
        if latitude != nil, longitude != nil {
            let favoriteCity = FavoriteCity(latitude: latitude, longitude: longitude)
            
            DispatchQueue.main.async {
                self.dbManager.save(city: favoriteCity)
            }
        }
    }
    
    @IBAction func showFavoriteCities(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Pop", sender: self)
        
        print(dbManager.fetchCities())
    }
    
    // MARK: - Managers, UI, other configurators
    private func configureUI() {
        mapView.layer.cornerRadius = 8
        mapView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        placePhotoImageView.layer.cornerRadius = 8
        placePhotoImageView.clipsToBounds = true
        placePhotoImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        topStackView.addBackgroundColor(color: UIColor(displayP3Red: 0.041, green: 0.031, blue: 0.092, alpha: 0.71))
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
    }
    
    // MARK: - Functionality methods
    private func getCurrentWeatherWithCoordinates(latitude: Double, longitude: Double) {
        weatherManager.fetchCurrentWeatherWith(coordinates: Coord(lat: latitude, lon: longitude)) { currentWeather in
            self.title = currentWeather.name
            
            if let temperature = currentWeather.main?.temp {
                self.temperatureLabel.text = String(format: "%.0f", temperature) + "°"
            }
            if let icon = currentWeather.weather?[0].icon {
                let iconImage = WeatherConditionIconManager(rawValue: icon)
                self.sunStateImageView.image = iconImage.image
            }
            if let weatherDescription = currentWeather.weather?[0].weatherDescription {
                self.weatherDescriptionLabel.text = "\(weatherDescription)"
            }
            if let humidity = currentWeather.main?.humidity {
                self.humidityLabel.text = "Humidity: \(humidity)%"
            }
            if let speed = currentWeather.wind?.speed {
                self.windSpeedLabel.text = "Wind speed: " + String(format: "%.1f", speed) + " m/s,  "
            }
            if let degree = currentWeather.wind?.deg {
                let direction = "\(Int(degree).windDirection())"
                self.windDirectionLabel .text = "  wind direction:  " + direction
            }
            
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    private func getFiveDayThreeHourForecastWithCoordinates(latitude: Double, longitude: Double) {
        weatherManager.fetchFiveDayThreeHourForecastWith(coordinates: Coord(lat: latitude, lon: longitude)) {
            fiveDayThreeHourForecast in
            
            self.threeHoursForecast = fiveDayThreeHourForecast
        }
    }
    
    private func getWeatherForCurrentLocation() {
        placesClient.currentPlace { placeLikelihoods, error in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    if let placeID = place.placeID {
                        self.getPhotoForPlaceID(placesClient: self.placesClient, placeID: placeID)
                    }
                    
                    self.mapView.camera = GMSCameraPosition(latitude: place.coordinate.latitude,
                                                            longitude: place.coordinate.longitude,
                                                            zoom: 10)
                    
                    self.getCurrentWeatherWithCoordinates(latitude: place.coordinate.latitude,
                                                          longitude: place.coordinate.longitude)
                    
                    self.getFiveDayThreeHourForecastWithCoordinates(latitude: place.coordinate.latitude,
                                                                    longitude: place.coordinate.longitude)
                    
                    self.latitude = place.coordinate.latitude
                    self.longitude = place.coordinate.longitude
                    
                    break
                }
            }
        }
    }
    
    private func getPhotoForPlaceID(placesClient: GMSPlacesClient, placeID: String) {
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))!
        
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
            (place: GMSPlace?, error: Error?) in
            
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            
            guard let place = place, let photoMetadata: GMSPlacePhotoMetadata = place.photos?.first else { return }
            
            placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                if let error = error {
                    print("Error loading photo metadata: \(error.localizedDescription)")
                    return
                } else {
                    self.placePhotoImageView?.image = photo;
                }
            })
        })
    }
    
}

extension MainViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.mapView.camera = GMSCameraPosition(latitude: place.coordinate.latitude,
                                                longitude: place.coordinate.longitude,
                                                zoom: 10)
        
        getCurrentWeatherWithCoordinates(latitude: place.coordinate.latitude,
                                         longitude: place.coordinate.longitude)
        
        getFiveDayThreeHourForecastWithCoordinates(latitude: place.coordinate.latitude,
                                                   longitude: place.coordinate.longitude)
        
        if let placeID = place.placeID {
            getPhotoForPlaceID(placesClient: placesClient, placeID: placeID)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension MainViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension MainViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let baseUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let radius = "radius=\(500)"
        let location = "location=\(coordinate.latitude),\(coordinate.longitude)"
        let apiKey = "AIzaSyAtUsFZoCXpk8MLCQGv7VHCADgxIzpMLls"
        let urlString = "\(baseUrl)?\(location)&\(radius)&rankby=prominence&sensor=true&key=\(apiKey)"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
            
        networkService.fetchJSONData(request: request, modelType: NearbyPlaces.self) { nearbyPlaces in
            if let placeID = nearbyPlaces?.results.first?.placeID {
                self.getPhotoForPlaceID(placesClient: self.placesClient, placeID: placeID)
            }
        }
        
        mapView.camera = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 10)
        getCurrentWeatherWithCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        getFiveDayThreeHourForecastWithCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
}
