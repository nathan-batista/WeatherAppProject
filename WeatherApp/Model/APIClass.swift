//
//  APIClass.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import Foundation
import PromiseKit

enum APIError:Error {
    case invalidURL
    case invalidLocation
}

class API{
    static public func request<T:Codable>(_ url:String) -> Promise<T>{
        //Crio uma promessa do tipo genérico e entao retorno a promessa ou um erro
        return firstly { () -> Promise<T> in
            if let safeURL = URL(string: url)  {
                let request = URLRequest(url: safeURL)
                //Transformo a promessa do tipo Data no tipo Genérico que desejo retornar
                return URLSession.shared.dataTask(.promise,with: request).map{
                    (data,response) -> T in
                    let decodedData = try JSONDecoder().decode(T.self,from:data)
                    return decodedData
                }
            } else {
                throw APIError.invalidURL
            }
        }
//        let apiURL = URL(string: url)!
//
//        let task = URLSession.shared.dataTask(with: apiURL, completionHandler: {
//            (data,response,error) in
//             if let error = error {
//                print("Fail When Looking For Weather : \(error)")
//                return
//            }
//             guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
//                print("Error with the response, unexpected status code: \(response)")
//                 return
//            }
//            if let data = data{
//                do{
//                    let decodedData = try JSONDecoder().decode(T.self, from: data)
//                    completionHandler(decodedData)
//                }
//                catch{
//                    print("Erro ao decodificar \(error)")
//                }
//
//            }
//        })
//        task.resume()
    }
}
