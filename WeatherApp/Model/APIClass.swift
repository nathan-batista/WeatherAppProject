//
//  APIClass.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import Foundation

class API{
    
    public func tempRequest(_ latitude:Float,_ longitude:Float, completionHandler: @escaping (WeatherList?) -> Void){
        let lat = String(format: "%.2f", latitude)
        let lon = String(format: "%.2f", longitude)
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=bd9d9e36d84edc52956d87da343a9e96&units=metric&lang=pt_br"
        request(url, completionHandler)
    }
    
    public func request(_ url:String, _ completionHandler: @escaping (WeatherList?) -> Void){
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
                    let weatherData = try JSONDecoder().decode(WeatherList.self, from: data)
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
