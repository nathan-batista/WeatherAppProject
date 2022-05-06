//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 29/04/22.
//

import Foundation
import CoreLocation


enum Errors: Error {
    case emptyLocations
}


struct WeatherService {
    static func makeRequest(coordinates:CLLocation,manager:CLLocationManager, completion: @escaping (WeatherList?) -> Void) {
        manager.stopUpdatingLocation()
        let lat = Float(coordinates.coordinate.latitude)
        let lon = Float(coordinates.coordinate.longitude)
        API.tempRequest(lat,lon,completionHandler: completion)
    }
    
    static func verifyHasLocation(locations: [CLLocation], coordinates: inout CLLocation?)->Result<Int,Error>{
        if !locations.isEmpty && coordinates == nil {
            return .success(0)
        }
        return .failure(Errors.emptyLocations)
    }
    
    static func callAPI(locations:[CLLocation], coordinates: inout CLLocation?,manager:CLLocationManager,completion:@escaping (WeatherList?) -> Void) {
        let response = verifyHasLocation(locations: locations, coordinates: &coordinates)
        switch response {
        case .success(let code):
            guard let newCoordinates = locations.first else {return}
            coordinates = newCoordinates
            makeRequest(coordinates: newCoordinates, manager: manager,completion: completion)
        case .failure(let code):
            return
        }
    }
    
    static func requestForCities(city:String,completion:@escaping ([City]?) -> Void){
        let url = "https://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=\(APIKey.cityAPIKey.rawValue)&q=\(city)&language=pt-br"
        API.request(url, completion)
    }
    
    
    //Uso de PromiseKit do framework Combine
    static func requestTempForCity(city:String,manager:CLLocationManager,completion:@escaping (WeatherList?) -> Void) {
        var coordinate:Coordinates?
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey.key.rawValue)"
        API.request(url){ (weather:WeatherCurrent?) in
            coordinate = weather?.coord
            DispatchQueue.main.async {
                if let safeCoordinates = coordinate {
                    let location = CLLocation(latitude: CLLocationDegrees(safeCoordinates.lat), longitude: CLLocationDegrees(safeCoordinates.lon))
                    makeRequest(coordinates: location, manager: manager, completion: completion)
                }
            }
        }
    }
}
