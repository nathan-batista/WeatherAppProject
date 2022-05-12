//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 29/04/22.
//

import Foundation
import PromiseKit

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
    
    func requestForCity(city:String) -> Promise<[City]>{
        return weatherAPI
            .requestForCities(city: city)
            .map{ cities in
                let cidades = cities.filter{$0.`Type`.lowercased() == "city"}
                var unique:[City] = []
                for city in cidades{
                    if !unique.contains(city) {
                        unique.append(city)
                    }
                }
                return unique
            }
        
//        
//        
//        { cities in
//            guard let safeCidades = cities else {return}
//            let cidades = safeCidades.filter{$0.`Type`.lowercased() == "city"}
//            var unique:[City] = []
//            for city in cidades{
//                if !unique.contains(city) {
//                    unique.append(city)
//                }
//            }
//            DispatchQueue.main.async {
//                delegate?.citiesFound(cidades: unique)
//            }
//        }
    }
    
    
    func getWeatherList() -> WeatherList? {
        return self.weatherList
    }
    
    func selectedTempCity(city:String) -> Promise<WeatherList>{
       return weatherAPI.requestTempForCity(city: city)
//        {
//            (weather:WeatherList?) in
//            self.weatherList = weather
//            DispatchQueue.main.async {
//                delegate?.didUpdateWeather()
//            }
//        }
    }
    
    func requestWeather() -> Promise<WeatherList>{
        return firstly { () -> Promise<[Double]> in
            guard let location = CoreLocationManagerStruct.shared.getLocation() else {throw APIError.invalidLocation}
            return Promise.value(location)
        }.then { location -> Promise<WeatherList> in
            return self.weatherAPI.makeRequest(latitude:location[0] ,longitude:location[1])
        }
    }
    
    func requestWeatherCurrentLocation()-> Promise<WeatherList>{
        return CoreLocationManagerStruct
            .shared
            .updateLocation()
            .then { _ -> Promise<WeatherList> in
                self.requestWeather()
            }
    }
}
