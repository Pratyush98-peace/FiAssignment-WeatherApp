//
//  FiAssignmentWeatherAppApp.swift
//  FiAssignmentWeatherApp
//
//  Created by Pratyush Jha on 08/03/23.
//

import Foundation

struct WeatherDetail {
    var city: String
    var minTemp: Double
    var maxTemp: Double
    var epochTime: Double
    var weatherText: String
}

struct FetchCity: Decodable {
    var localizedName: String
    
    enum CodingKeys: String, CodingKey {
        case localizedName = "LocalizedName"
    }
}

struct Weather: Decodable {
    let headline: Headlines
    let dailyForecasts: [DailyForecast]
    
    enum CodingKeys: String, CodingKey {
        case headline = "Headline"
        case dailyForecasts = "DailyForecasts"
    }
}

struct Headlines: Decodable {
    let effectiveEpochDate: Double
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case effectiveEpochDate = "EffectiveEpochDate"
        case text = "Text"
    }
}

struct DailyForecast: Decodable {
    let temperature: TemperatureData
    
    enum CodingKeys: String, CodingKey {
        case temperature = "Temperature"
    }
}

struct TemperatureData: Decodable {
    let minimum: TempDetails
    let maximum: TempDetails
    
    enum CodingKeys: String, CodingKey {
        case minimum = "Minimum"
        case maximum = "Maximum"
    }
}

struct TempDetails: Decodable {
    let value: Double
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
    }
}
  
