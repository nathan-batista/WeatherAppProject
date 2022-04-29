//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 29/04/22.
//

import Foundation
import CoreLocation


struct WeatherService {
    static func makeRequest(coordinates:CLLocation,manager:CLLocationManager,APIController:API, completion: @escaping (WeatherAPIData?) -> Void) {
        manager.stopUpdatingLocation()
        let lat = Float(coordinates.coordinate.latitude)
        let lon = Float(coordinates.coordinate.longitude)
        APIController.request(lat,lon,completion)
    }
    
    static func verifyHasLocation(locations: [CLLocation], coordinates:CLLocation?)->Bool{
        return !locations.isEmpty && coordinates == nil
    }
}
