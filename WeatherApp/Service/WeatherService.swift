//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 29/04/22.
//

import Foundation
import Combine

class WeatherService{
    
    let weatherAPI = WeatherAPI()
    @Published var weatherList:WeatherList? = nil
    var locationCancellable:Cancellable?
    var cancellables = Set<AnyCancellable>()
    
    init() {
        locationCancellable = CoreLocationManagerStruct.shared.$didAllowLocation
            .sink { value in
                if let safeValue = value {
                    if safeValue {
                        CoreLocationManagerStruct.shared.updateLocation()
                    }
                }
            }
        
        CoreLocationManagerStruct.shared.$location
            .sink { value in
                if let value = value {
                    let lat = Double(value.coordinate.latitude)
                    let lon = Double(value.coordinate.longitude)
                    self.requestWeather(coordinate: Coordinates(lon: lon, lat: lat))
                        .sink(receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                print(error)
                            }
                        }) { weather in
                            DispatchQueue.main.async {
                                self.weatherList = weather
                            }
                        }
                        .store(in: &self.cancellables)
                }
            }
            .store(in: &cancellables)
    }
    
    
    func requestForCity(city:String) -> Future<[City],Error>{
        //Request for cities me retornará uma promessa de [City] e entao tratarei para remover as cidades iguais
        
        return Future<[City], Error> { promise in
            self.weatherAPI.requestForCities(city: city)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as APIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(APIError.unknown))
                        }
                    }
                }, receiveValue: { cities in
                    let cidades = cities.filter{$0.`Type`.lowercased() == "city"}
                    var unique:[City] = []
                    for city in cidades{
                        if !unique.contains(city) {
                            unique.append(city)
                        }
                    }
                    promise(.success(unique))
                })
                .store(in: &self.cancellables)
        }
//        return weatherAPI
//            .requestForCities(city: city)
//            .map{ (cities:[City]) -> [City] in
//                let cidades = cities.filter{$0.`Type`.lowercased() == "city"}
//                var unique:[City] = []
//                for city in cidades{
//                    if !unique.contains(city) {
//                        unique.append(city)
//                    }
//                }
//                return unique
//            }
    }
    
    
//    func requestForCity(city:String) -> Promise<[City]>{
//        //Request for cities me retornará uma promessa de [City] e entao tratarei para remover as cidades iguais
//        return weatherAPI
//            .requestForCities(city: city)
//            .map{ cities in
//                let cidades = cities.filter{$0.`Type`.lowercased() == "city"}
//                var unique:[City] = []
//                for city in cidades{
//                    if !unique.contains(city) {
//                        unique.append(city)
//                    }
//                }
//                return unique
//            }
//    }
//
    
    func getWeatherList() -> WeatherList? {
        return self.weatherList
    }
    
//    func selectedTempCity(city:String) -> Promise<WeatherList>{
//        //Retorno a promessa de WeatherList que irei receber da funcao requestTempForCity
//       return weatherAPI.requestTempForCity(city: city)
//    }
    
    func selectedTempCity(city:String) -> Future<WeatherList,Error>{
        //Retorno a promessa de WeatherList que irei receber da funcao requestTempForCity
        return Future<WeatherList,Error> { promise in 
            self.weatherAPI.requestTempForCity(city: city)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as APIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(APIError.unknown))
                        }
                    }
                }) { value in
                    promise(.success(value))
                }
                .store(in: &self.cancellables)
        }
    }
    
    func requestWeather(coordinate: Coordinates) -> Future<WeatherList, Error>{
        return Future { promise in
            self.weatherAPI.makeRequest(latitude: coordinate.lat, longitude: coordinate.lon)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as APIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(APIError.unknown))
                        }
                    }
                }) { value in
                    promise(.success(value))
                }
                .store(in: &self.cancellables)
        }

        
//        //Crio uma promise q me diz q receberei um vetor de double
//        return firstly { () -> Promise<[Double]> in
//            guard let location = CoreLocationManagerStruct.shared.getLocation() else {throw APIError.invalidLocation}
//            return Promise.value(location)
//        }
//        //Após o término da promise anterior utilizo o vetor de double para obter uma Promessa de q terei um Weather List
//        .then { location -> Promise<WeatherList> in
//            return self.weatherAPI.makeRequest(latitude:location[0] ,longitude:location[1])
//        }
    }
    
//    func requestWeatherCurrentLocation()-> Promise<WeatherList>{
//        //Terei uma promise para me avisar quando a localizaçao foi obtida
//        return CoreLocationManagerStruct
//            .shared
//            .requestLocation()
//            .then { _ -> Promise<Bool> in
//                CoreLocationManagerStruct.shared.updateLocation()
//            }
//            .then { _ -> Promise<WeatherList> in
//                self.requestWeather()
//            }
////        return CoreLocationManagerStruct
////            .shared
////            .updateLocation()
////        //Ao obter a localização realizo uma chamada para obter a temperatura
////            .then { _ -> Promise<WeatherList> in
////                self.requestWeather()
////            }
//    }
    
    func getCityNameForCurrentLocation() -> Future<String,Error>{
        return CoreLocationManagerStruct.shared.getCityName()
    }
}
