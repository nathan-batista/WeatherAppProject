//
//  Parsers.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 28/04/22.
//
import Foundation


//Enum com valores especificos
enum WeatherFields:String{
    case temp_min = "Temp. Min:"
    case temp_max = "Temp. Máx:"
    case humidity = "Umidade:"
    case feels_like = "Sensação Térmica:"
    case pressure = "Pressão:"
}

struct DateGetter {
    static func getCurrentDate() -> [Int]?{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day,.month], from: date)
        if let day = components.day,let month = components.month{
            return [day,month]
        }
        return nil
    }
    
    static func getDayByOffset(offset: Int) -> Int {
        var today = NSDate()
        var res = today.addingTimeInterval(Double(offset)*24*60*60)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: res as Date)
        return components.day!
    }
}

struct ImageGetter{
    static func getImage(_ weather:Weather) -> String{
        switch(weather.id){
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.rain.fill"
        case 500...531:
            return "cloud.sun.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 700...781:
            return "cloud.fog.fill"
        case 800:
            return "sun.max.fill"
        default:
            return "cloud.fill"
        }
    }
}
