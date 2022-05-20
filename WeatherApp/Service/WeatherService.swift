//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 29/04/22.
//

import Foundation
import PromiseKit

class WeatherService{
    
   // let coreLocation = CoreLocationManagerStruct()
    let weatherAPI = WeatherAPI()
    private var weatherList:WeatherList? = nil
    
    func requestForCity(city:String) -> Promise<[City]>{
        //Request for cities me retornará uma promessa de [City] e entao tratarei para remover as cidades iguais
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
    }
    
    
    func getWeatherList() -> WeatherList? {
        return self.weatherList
    }
    
    func selectedTempCity(city:String) -> Promise<WeatherList>{
        //Retorno a promessa de WeatherList que irei receber da funcao requestTempForCity
       return weatherAPI.requestTempForCity(city: city)
    }
    
    func requestWeather() -> Promise<WeatherList>{
        //Crio uma promise q me diz q receberei um vetor de double
        return firstly { () -> Promise<[Double]> in
            guard let location = CoreLocationManagerStruct.shared.getLocation() else {throw APIError.invalidLocation}
            return Promise.value(location)
        }
        //Após o término da promise anterior utilizo o vetor de double para obter uma Promessa de q terei um Weather List
        .then { location -> Promise<WeatherList> in
            return self.weatherAPI.makeRequest(latitude:location[0] ,longitude:location[1])
        }
    }
    
    func requestWeatherCurrentLocation()-> Promise<WeatherList>{
        //Terei uma promise para me avisar quando a localizaçao foi obtida
        return CoreLocationManagerStruct
            .shared
            .requestLocation()
            .then { _ -> Promise<Bool> in
                CoreLocationManagerStruct.shared.updateLocation()
            }
            .then { _ -> Promise<WeatherList> in
                self.requestWeather()
            }
//        return CoreLocationManagerStruct
//            .shared
//            .updateLocation()
//        //Ao obter a localização realizo uma chamada para obter a temperatura
//            .then { _ -> Promise<WeatherList> in
//                self.requestWeather()
//            }
    }
    
    func getCityNameForCurrentLocation() -> Promise<String>{
        return CoreLocationManagerStruct.shared.getCityName()
    }
}
