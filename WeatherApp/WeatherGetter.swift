//
//  FiAssignmentWeatherAppApp.swift
//  FiAssignmentWeatherApp
//
//  Created by Pratyush Jha on 08/03/23.
//

import Foundation

protocol WeatherGetterDelegate {
    func didGetWeather(weather: WeatherDetail)
    func didNotGetWeather()
}

final class WeatherGetter {
    
    private let openWeatherMapAPIKey = "CcG4cAeMDmabt6HdAk2aISlupqyfvdgB"
    private var delegate: WeatherGetterDelegate
    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    func getCurrentCity(latitude: Double, longitude: Double) {
        var url = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
        url = url + "?apikey=fXfnxixtabzeypoj42GispgxYbck2tV2&q=\(latitude),\(longitude)"
        let request = URLRequest(url: URL(string: url)!)
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data,
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                  error == nil else { return }
            let cityName = jsonData["LocalizedName"] as? String
            guard let cityName = cityName else { return }
            self.getWeather(city: cityName)
        }
        dataTask.resume()
    }
    
    func getWeather(city: String) {
        let url = "http://dataservice.accuweather.com/locations/v1/cities/search?apikey=fXfnxixtabzeypoj42GispgxYbck2tV2&q=\(city)"
        guard let urlWrapped = URL(string: url) else {
            self.delegate.didNotGetWeather()
            return
        }
        let request = URLRequest(url: urlWrapped)
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data,
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]],
                  error == nil else {
                self.delegate.didNotGetWeather()
                return
            }
            let key = jsonData.first?["Key"]
            guard let key = key else {
                self.delegate.didNotGetWeather()
                return
            }
            self.getWeatherDataOfCity(key: key as! String, city: city)
        }
        dataTask.resume()
    }
    
    func getWeatherDataOfCity(key: String, city: String) {
        var url = "http://dataservice.accuweather.com/forecasts/v1/daily/1day/" + key
        url = url+"?apikey=fXfnxixtabzeypoj42GispgxYbck2tV2"
        let request = URLRequest(url: URL(string: url)!)
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data,
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                  error == nil else { return }
            guard let weatherDetails = try? JSONDecoder().decode(Weather.self, from: jsonData) else { return }
            let minTemp = weatherDetails.dailyForecasts.first?.temperature.minimum.value ?? 0
            let maxTemp = weatherDetails.dailyForecasts.first?.temperature.maximum.value ?? 0
            let epoch = weatherDetails.headline.effectiveEpochDate
            let weatherText = weatherDetails.headline.text
            let weather = WeatherDetail(city: city, minTemp: minTemp, maxTemp: maxTemp, epochTime: epoch, weatherText: weatherText)
            self.delegate.didGetWeather(weather: weather)
        }
        dataTask.resume()
    }
}

public extension JSONDecoder {
    func decode<T>(_ type: T.Type, from jsonDictionary: [String: Any]) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
        return try decode(type, from: jsonData)
    }
}

