//
//  CoreLocationService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 06/05/22.
//

import Foundation
import CoreLocation

//protocol didUpdateLocation{
//    func newLocationFound()
//}

class CoreLocationManagerStruct: NSObject, CLLocationManagerDelegate{
    private var manager = CLLocationManager()
    private var location:CLLocation?
    
    private var delegate: updatedData?
    
    public static var shared = CoreLocationManagerStruct()
    
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    
    }
    
        
    //Passar a requisicao da API para um WeatherService e mudar a verificação do location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.location != locations.last {
            self.location = locations.last
            manager.stopUpdatingLocation()
            delegate?.didUpdateLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func updateLocation(delegate:updatedData?){
        self.delegate = delegate
        manager.requestLocation()
    }
    
    func getLocation() -> [Double]? {
        guard let safeLocation = location else {return nil}
        return [safeLocation.coordinate.latitude,safeLocation.coordinate.longitude]
    }
}

