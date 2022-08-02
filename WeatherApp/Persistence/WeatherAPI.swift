//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 06/05/22.
//

import Foundation
import Combine

class WeatherAPI {
    
    var cancellable =  Set<AnyCancellable>()
    
    func makeRequest(latitude:Double,longitude:Double) -> Future<WeatherList,Error> {
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly&appid=\(APIKey.key.rawValue)&units=metric&lang=pt_br"
        //retorno a promise com as temperaturas obtidas
        
        //Porque nao funciona declarando o cancellable aqui dentro?
        return Future<WeatherList,Error> { promise in
            API.shared.request(url)
                .sink { completion in
                    if case (let error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as APIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(APIError.unknown))
                        }
                    }
                } receiveValue: { weather in
                    promise(.success(weather))
                }
                .store(in: &self.cancellable)

        }
    }
    
    func requestForCities(city:String) -> Future<[City],Error>{
        
        //Porque ele funciona mesmo sem eu ter nenhum cancellable?
        let url = "https://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=\(APIKey.cityAPIKey.rawValue)&q=\(city)&language=pt-br"
        //Recebo uma promise com as cidades da pesquisa
        let future: Future<[City],Error> = API.shared.request(url)
        
        return future
        
    }
    
    func requestTempForCity(city:String) -> Future<WeatherList,Error> {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey.key.rawValue)"
        
        
        //Após a promise ser cumprida utilizo a localização obtida para fazer request da temperatura
        return Future<WeatherList, Error> { promise in
            //Obtenho a promise do tipo weatherCurrent com os dados da minha cidade atual
            API.shared.request(url)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { (city:WeatherCurrent) in
                    self.makeRequest(latitude: city.coord.lat,
                                     longitude: city.coord.lon)
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
                    }, receiveValue: { weatherList in
                        promise(.success(weatherList))
                    })
                    .store(in: &self.cancellable)
                }
                .store(in: &self.cancellable)
        }
    }
    
}

