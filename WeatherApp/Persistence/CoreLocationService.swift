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
    //Manter referencia para promessa e resolver e disparar qnd obtiver autorização da localização
    private var promiseAuthorization: (Promise<Bool>, Resolver<Bool>)?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    
    //Passar a requisicao da API para um WeatherService e mudar a verificação do location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.location != locations.last {
            self.location = locations.last
            manager.stopUpdatingLocation()
            //Aviso ao resolver para disparar que a promise foi satisfeita
            self.promiseLocation?.1.fulfill(true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch (manager.authorizationStatus) {
            //Verifico se obtive autorizacao e digo q promessa foi satisfeita
        case .authorizedAlways, .authorizedWhenInUse:
            self.promiseAuthorization?.1.fulfill(true)
            break
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        let status: CLAuthorizationStatus = manager.authorizationStatus
        print(status.rawValue)
    }
    
    func requestLocation() -> Promise<Bool> {
        //Solicito autorizacao e crio promessa para ser disparada futuramente
        manager.requestWhenInUseAuthorization()
        let promiseAuth = Promise<Bool>.pending()
        promiseAuthorization = promiseAuth
        return promiseAuth.promise
    }
    
    func updateLocation() -> Promise<Bool> {
        //Crio uma promessa e um resolver para ser disparado no futuro e associo a minha referência
        manager.requestLocation()
        let promiseExpectation = Promise<Bool>.pending()
        promiseLocation = promiseExpectation
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

