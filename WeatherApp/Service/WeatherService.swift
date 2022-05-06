//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 29/04/22.
//

import Foundation
import UIKit

protocol updatedData{
    func didUpdateWeather()
    func citiesFound(cidades:[City])
}

class WeatherService{
    
    let coreLocation = CoreLocationManagerStruct()
    let weatherAPI = WeatherAPI()
    private var weatherList:WeatherList? = nil
    var delegate:updatedData?
    
    func requestForCity(city:String){
        weatherAPI.requestForCities(city: city) { cities in
            guard let safeCidades = cities else {return}
            let cidades = safeCidades.filter{$0.`Type`.lowercased() == "city"}
            var unique:[City] = []
            for city in cidades{
                if !unique.contains(city) {
                    unique.append(city)
                }
            }
            DispatchQueue.main.async {
                self.delegate?.citiesFound(cidades: unique)
            }
        }
    }
    
    func setup(delegate: didUpdateLocation ){
        coreLocation.delegate = delegate
        coreLocation.setupLocation()
    }
    
    func getWeatherList() -> WeatherList? {
        return self.weatherList
    }
    
    func selectedTempCity(city:String){
        weatherAPI.requestTempForCity(city: city){
            (weather:WeatherList?) in
            self.weatherList = weather
            DispatchQueue.main.async {
                self.delegate?.didUpdateWeather()
            }
        }
    }
    
    func requestWeather(){
        guard let location = coreLocation.getLocation() else {return}
        weatherAPI.makeRequest(latitude:location[0] ,longitude:location[1]){ weather in
            self.weatherList = weather
            DispatchQueue.main.async {
                self.delegate?.didUpdateWeather()
            }
        }
    }
}
