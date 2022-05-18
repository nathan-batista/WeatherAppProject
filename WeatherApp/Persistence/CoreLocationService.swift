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
    
    public static var shared = CoreLocationManagerStruct()
    
    //Mantenho uma referencia para uma promessa e um resolver para ser disparada quando for necessário
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
            
            //Aviso ao resolver para disparar que a promise foi satisfeita
            self.promiseLocation?.1.fulfill(true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func updateLocation() -> Promise<Bool> {
        //Crio uma promessa e um resolver para ser disparado no futuro e associo a minha referência
        let promiseExpectation = Promise<Bool>.pending()
        promiseLocation = promiseExpectation
        manager.requestLocation()
        return promiseExpectation.promise
    }
    
    func getLocation() -> [Double]? {
        guard let safeLocation = location else {return nil}
        return [safeLocation.coordinate.latitude,safeLocation.coordinate.longitude]
    }
    
    func getCityName()  -> Promise<String> {
        //Crio uma promessa
        return Promise { seal in
            if let safeLocation = self.location {
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(safeLocation){ placemark,error in
                    //Aciono um resolve que resolvera a promessa seja com sucesso ou erro(placemark caso sucesso/error caso falhe)
                    seal.resolve(placemark,error)
                }
            } else {
                seal.reject(APIError.invalidLocation)
            }
        }
        //Mapeio a minha promessa de [CLPlacemark]? em uma string
        .map { (placemark:[CLPlacemark]?) -> String in
            //Verifico se placemark é vazio, caso n seja eu pego o primeiro elemento
            if let placemarks = placemark {
                let cityName = placemarks[0].locality ?? "Erro"
                return cityName
            } else {
                throw APIError.invalidLocation
            }
        }
    }
}

