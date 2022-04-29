//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 29/04/22.
//

import Foundation
import CoreLocation


struct WeatherService {
    static func makeRequest(coordinates:CLLocation,manager:CLLocationManager,APIController:API, completion: @escaping (WeatherList?) -> Void) {
        manager.stopUpdatingLocation()
        let lat = Float(coordinates.coordinate.latitude)
        let lon = Float(coordinates.coordinate.longitude)
        APIController.tempRequest(lat,lon,completionHandler: completion)
    }
    
    static func verifyHasLocation(locations: [CLLocation], coordinates:CLLocation?)->Bool{
        return !locations.isEmpty && coordinates == nil
    }
}
