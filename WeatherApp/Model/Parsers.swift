//
//  Parsers.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 28/04/22.
//
import Foundation

enum WeatherFields{
    case temp_min
    case temp_max
    case humidity
    case feels_like
    case pressure
}

struct DateGetter {
    static func getCurrentDate()-> [Int]?{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day,.month], from: date)
        if let day = components.day,let month = components.month{
            return [day,month]
        }
        return nil
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
