//
//  APIClass.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import Foundation

class API{
    public func request(_ url:String, _ completionHandler: @escaping (WeatherAPIData?) ->Void){
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
                    let weatherData = try JSONDecoder().decode(WeatherAPIData.self, from: data)
                    completionHandler(weatherData)
                }
                catch{
                    print("Erro ao decodificar \(error)")
                }
                
            }
        })
        task.resume()
    }
}
