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
        //APIKey é um enum contendo a minha chave para a api openweather, para utilizar o código crie um arquivo MyAPI e o enum APIKey c a sua chave de api
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly&appid=\(APIKey.key.rawValue)&units=metric&lang=pt_br"
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
