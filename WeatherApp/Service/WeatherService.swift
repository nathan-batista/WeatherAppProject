//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 29/04/22.
//

import Foundation

protocol updatedData{
    //Atualiza UI com os novos dados
    func didUpdateWeather()
    //Atualiza as cidades obtidas
    func citiesFound(cidades:[City])
    //Avisa que localizacao foi obtida
    func didUpdateLocation()
}

class WeatherService{
    
   // let coreLocation = CoreLocationManagerStruct()
    let weatherAPI = WeatherAPI()
    private var weatherList:WeatherList? = nil
    
    func requestForCity(city:String,delegate:updatedData?){
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
                delegate?.citiesFound(cidades: unique)
            }
        }
    }
    
    
    func getWeatherList() -> WeatherList? {
        return self.weatherList
    }
    
    func selectedTempCity(city:String,delegate:updatedData?){
        weatherAPI.requestTempForCity(city: city){
            (weather:WeatherList?) in
            self.weatherList = weather
            DispatchQueue.main.async {
                delegate?.didUpdateWeather()
            }
        }
    }
    
    func requestWeather(delegate:updatedData?){
        guard let location = CoreLocationManagerStruct.shared.getLocation() else {return}
        weatherAPI.makeRequest(latitude:location[0] ,longitude:location[1]){ weather in
            self.weatherList = weather
            DispatchQueue.main.async {
                delegate?.didUpdateWeather()
            }
        }
    }
    
    func requestWeatherCurrentLocation(delegate: updatedData?){
        CoreLocationManagerStruct.shared.updateLocation(delegate:delegate)
    }
}
