//
//  FiAssignmentWeatherAppApp.swift
//  FiAssignmentWeatherApp
//
//  Created by Pratyush Jha on 08/03/23.
//

import UIKit
import MapKit

protocol GetCityProtocol: AnyObject {
    func getCity(cityDetail: String)
}

final class WeatherMainViewController: UIViewController, WeatherGetterDelegate {
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var weatherLabel: UILabel!
    @IBOutlet private weak var maxTemp: UILabel!
    @IBOutlet private weak var minTemp: UILabel!
    @IBOutlet private weak var epochLabel: UILabel!
    @IBOutlet private weak var weatherText: UILabel!
    @IBOutlet private weak var getCityWeatherButton: UIButton!
    
    private var locManager = CLLocationManager()
    private var currentLocation: CLLocation!
    
    private var city: String?
    private lazy var weather: WeatherGetter = WeatherGetter(delegate: self)
    private var defaultCity: String = "Nagpur"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLayout()
    }
    
    @IBAction private func getWeatherForCityButtonTapped(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "SearchCityIdentifier") as? SearchCityController
        guard let controller = controller else { return }
        controller.delegate = self
        self.present(controller,animated: true, completion: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    private func getLayout() {
        cityLabel.text = "simple weather"
        getCityWeatherButton.isEnabled = true
        getCurrentLocationData()
    }
    
    func didGetWeather(weather: WeatherDetail) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.maxTemp.text = String(weather.maxTemp)
            self.minTemp.text = String(weather.minTemp)
            self.epochLabel.text = String(weather.epochTime)
            self.weatherText.text = weather.weatherText
        }
    }
    
    func didNotGetWeather() {
        weather.getWeather(city: defaultCity)
    }
    
    private func getCurrentLocationData() {
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                weather.getWeather(city: defaultCity)
                return
            }
            weather.getCurrentCity(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        } else {
            weather.getWeather(city: defaultCity)
        }
    }
}

extension WeatherMainViewController: GetCityProtocol {
    func getCity(cityDetail: String) {
        weather.getWeather(city: cityDetail)
    }
}


