//
//  CoreLocationService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 06/05/22.
//

import Foundation
import CoreLocation
import Combine

//protocol didUpdateLocation{
//    func newLocationFound()
//}

class CoreLocationManagerStruct: NSObject, CLLocationManagerDelegate{
    private var manager = CLLocationManager()
    @Published var location:CLLocation?
    @Published var didAllowLocation: Bool?
    
    public static var shared = CoreLocationManagerStruct()
    
    //Mantenho uma referencia para uma promessa e um resolver para ser disparada quando for necessário
    //Manter referencia para promessa e resolver e disparar qnd obtiver autorização da localização
    
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
            //Aviso ao resolver para disparar que a promise foi satisfeita
        }
    }
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch (manager.authorizationStatus) {
            //Verifico se obtive autorizacao e digo q promessa foi satisfeita
        case .authorizedAlways, .authorizedWhenInUse:
            self.didAllowLocation = true
            break
        default:
            self.didAllowLocation = false
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        let status: CLAuthorizationStatus = manager.authorizationStatus
        print(status.rawValue)
    }
    
    func updateLocation() {
        //Crio uma promessa e um resolver para ser disparado no futuro e associo a minha referência
        manager.requestLocation()
    }
    
//    func getLocation() -> [Double]? {
//        guard let safeLocation = location else { return nil }
//        return [safeLocation.coordinate.latitude,safeLocation.coordinate.longitude]
//    }
    
    func getCityName()  -> Future<String,Error> {
        //Crio uma promessa
        return Future { promise in
            if let safeLocation = self.location {
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(safeLocation){ placemark,error in
                    //Aciono um resolve que resolvera a promessa seja com sucesso ou erro(placemark caso sucesso/error caso falhe)
                    if let placemarks = placemark {
                        let cityName = placemarks[0].locality ?? "Erro"
                        promise(.success(cityName))
                    } else {
                        promise(.failure(APIError.invalidLocation))
                    }
                }
            } else {
                promise(.failure(APIError.responseError))
            }
        }
        
//        return Promise { seal in
//            if let safeLocation = self.location {
//                let geoCoder = CLGeocoder()
//                geoCoder.reverseGeocodeLocation(safeLocation){ placemark,error in
//                    //Aciono um resolve que resolvera a promessa seja com sucesso ou erro(placemark caso sucesso/error caso falhe)
//                    seal.resolve(placemark,error)
//                }
//            } else {
//                seal.reject(APIError.invalidLocation)
//            }
//        }
//        //Mapeio a minha promessa de [CLPlacemark]? em uma string
//        .map { (placemark:[CLPlacemark]?) -> String in
//            //Verifico se placemark é vazio, caso n seja eu pego o primeiro elemento
//            if let placemarks = placemark {
//                let cityName = placemarks[0].locality ?? "Erro"
//                return cityName
//            } else {
//                throw APIError.invalidLocation
//            }
//        }
        
    }
}

