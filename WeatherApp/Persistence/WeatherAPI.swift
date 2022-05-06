//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 06/05/22.
//

import Foundation

struct WeatherAPI {
    
    func makeRequest(latitude:Double,longitude:Double,completion: @escaping (WeatherList?) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly&appid=\(APIKey.key.rawValue)&units=metric&lang=pt_br"
        API.request(url, completion)
    }
    
    func requestForCities(city:String,completion:@escaping ([City]?) -> Void){
        let url = "https://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=\(APIKey.cityAPIKey.rawValue)&q=\(city)&language=pt-br"
        API.request(url, completion)
    }
    
    //Uso de PromiseKit do framework Combine
    func requestTempForCity(city:String,completion:@escaping (WeatherList?) -> Void) {
        var coordinate:Coordinates?
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey.key.rawValue)"
        API.request(url){ (weather:WeatherCurrent?) in
            coordinate = weather?.coord
            DispatchQueue.main.async {
                if let safeCoordinates = coordinate {
                    makeRequest(latitude: safeCoordinates.lat, longitude: safeCoordinates.lon, completion: completion)
                }
            }
        }
    }
}
