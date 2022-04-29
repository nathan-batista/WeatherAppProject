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
    static func makeRequest(coordinates:CLLocation,manager:CLLocationManager,APIController:API, completion: @escaping (WeatherList?) -> Void) {
        manager.stopUpdatingLocation()
        let lat = Float(coordinates.coordinate.latitude)
        let lon = Float(coordinates.coordinate.longitude)
        APIController.tempRequest(lat,lon,completionHandler: completion)
    }
    
    static func verifyHasLocation(locations: [CLLocation], coordinates:CLLocation?)->Result<Int,Error>{
        if !locations.isEmpty && coordinates == nil {
            return .success(0)
        }
        return .failure(Errors.emptyLocations)
    }
    
    static func callAPI(locations:[CLLocation],coordinates:CLLocation?,manager:CLLocationManager,APIController:API,completion:@escaping (WeatherList?) -> Void) {
        let response = verifyHasLocation(locations: locations, coordinates: coordinates)
        switch response {
        case .success(let code):
            guard let newCoordinates = locations.first else {return}
            makeRequest(coordinates: newCoordinates, manager: manager, APIController: APIController, completion: completion)
        case .failure(let code):
            return
        }
    }
}
