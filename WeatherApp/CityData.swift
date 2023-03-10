//
//  CityData.swift
//  WeatherApp
//
//  Created by Lokesh Bhansali on 10/03/23.
//  Copyright © 2023 Joey deVilla. All rights reserved.
//

import Foundation

class CityData {
    var storeCity: [String] = []
    
    static let shared: CityData = CityData()
    
    private init() {
    }
    
    func operationInStoreCity(city: String) {
        if(storeCity.count == 5) {
            storeCity.removeFirst()
        }
        storeCity.append(city)
    }
}
