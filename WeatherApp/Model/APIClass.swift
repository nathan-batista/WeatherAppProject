//
//  APIClass.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import Foundation

class API{
    static public func request<T:Codable>(_ url:String, _ completionHandler: @escaping (T?) -> Void){
        let apiURL = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: apiURL, completionHandler: {
            (data,response,error) in
             if let error = error {
                print("Fail When Looking For Weather : \(error)")
                return
            }
             guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                 return
            }
            if let data = data{
                do{
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(decodedData)
                }
                catch{
                    print("Erro ao decodificar \(error)")
                }
                
            }
        })
        task.resume()
    }
}
