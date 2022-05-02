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
        var imageName = ""
        if weather.main.lowercased() == "clear" {
            imageName = "clear"
        }
        else if weather.main.lowercased() == "clouds" {
            imageName = "clouds"
        } else if weather.main.lowercased() == "rain" {
            imageName = "rain"
        }
        else {
            imageName = "sun"
        }
        return imageName
    }
}
