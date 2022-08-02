//
//  APIClass.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import Foundation
import Combine
enum APIError:Error {
    case invalidURL
    case invalidLocation
    case responseError
    case unknown
}

class API{
    
    static let shared = API()
    
    private var cancellables = Set<AnyCancellable>()
    
    public func request<T:Codable>(_ url:String) -> Future<T,Error>{
        //Crio uma promessa do tipo genérico e entao retorno a promessa ou um erro
        return Future<T,Error> { promise in
            guard let url = URL(string: url) else {
                return promise(.failure(APIError.invalidURL))
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw APIError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
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
                }, receiveValue: { value in
                    promise(.success(value))
                })
                .store(in: &self.cancellables)
        }
    }
}
