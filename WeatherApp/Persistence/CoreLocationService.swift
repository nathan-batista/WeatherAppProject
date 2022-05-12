//
//  CoreLocationService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 06/05/22.
//

import Foundation
import CoreLocation
import PromiseKit

//protocol didUpdateLocation{
//    func newLocationFound()
//}

class CoreLocationManagerStruct: NSObject, CLLocationManagerDelegate{
    private var manager = CLLocationManager()
    private var location:CLLocation?
    
//    private var delegate: updatedData?
    
    public static var shared = CoreLocationManagerStruct()
    
    private var promiseLocation: (Promise<Bool>, Resolver<Bool>)?
    
    
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
           // delegate?.didUpdateLocation()
            self.promiseLocation?.1.fulfill(true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func updateLocation() -> Promise<Bool> {
//        self.delegate = delegate
        promiseLocation = Promise<Bool>.pending()
        manager.requestLocation()
        return promiseLocation?.0 ?? Promise.value(false)
    }
    
    func getLocation() -> [Double]? {
        guard let safeLocation = location else {return nil}
        return [safeLocation.coordinate.latitude,safeLocation.coordinate.longitude]
    }
}

