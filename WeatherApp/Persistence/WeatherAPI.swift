//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 06/05/22.
//

import Foundation
import PromiseKit

struct WeatherAPI {
    
    func makeRequest(latitude:Double,longitude:Double) -> Promise<WeatherList> {
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly&appid=\(APIKey.key.rawValue)&units=metric&lang=pt_br"
        //retorno a promise com as temperaturas obtidas
        return API.request(url)
    }
    
    func requestForCities(city:String) -> Promise<[City]>{
        
        let url = "https://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=\(APIKey.cityAPIKey.rawValue)&q=\(city)&language=pt-br"
        //Recebo uma promise com as cidades da pesquisa
        let promise: Promise<[City]> = API.request(url)
        
        return promise

    }
    
    //Uso de PromiseKit do framework Combine
    func requestTempForCity(city:String) -> Promise<WeatherList> {
            var coordinate:Coordinates?
            let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey.key.rawValue)"
        
        //Obtenho a promise do tipo weatherCurrent com os dados da minha cidade atual
        let promise: Promise<WeatherCurrent> = API.request(url)
        
        //Após a promise ser cumprida utilizo a localização obtida para fazer request da temperatura
        return promise
            .then { city -> Promise<WeatherList> in
            self.makeRequest(latitude: city.coord.lat,
                             longitude: city.coord.lon)
        }
        
        
        
//        {(city:WeatherCurrent) -> Promise<WeatherList>
//
//            self.makeRequest(latitude: city.coord.lat, longitude: city.coord.lon)
//
//        }
        
//                .done { (decodedData:WeatherCurrent) in
//                    coordinate = decodedData.coord
//                    makeRequest(latitude: coordinate?.lat ?? 0, longitude: coordinate?.lon ?? 0)
//                }.catch {error in
//                    print(error)
//                }

        
        //        { (weather:WeatherCurrent?) in
        //            coordinate = weather?.coord
        //            DispatchQueue.main.async {
        //                if let safeCoordinates = coordinate {
        //                    makeRequest(latitude: safeCoordinates.lat, longitude: safeCoordinates.lon, completion: completion)
        //                }
        //            }
        //        }
    }
}
