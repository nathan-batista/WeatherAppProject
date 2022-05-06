//
//  WeatherStructs.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import Foundation

struct WeatherList:Codable {
    let timezone:String
    let timezone_offset:Int
    let current:WeatherAPIData
    let daily:[WeatherAPIDataDay]
}

struct WeatherAPIDataDay:Codable {
    let dt:Int
    let sunrise:Int
    let sunset:Int
    let temp:Temp
    let feels_like:FeelsLike
    let pressure:Int
    let humidity:Int
    let weather:[Weather]
}

struct Temp:Codable {
    let day:Float
    let min:Float
    let max:Float
}
struct FeelsLike:Codable {
    let day:Float
    let night:Float
}


struct WeatherAPIData:Codable{
    let dt:Int
    let sunrise:Int
    let sunset:Int
    let temp:Float
    let feels_like:Float
    let pressure:Int
    let humidity:Int
    let weather:[Weather]
}

struct Weather : Codable {
    let id:Int
    let main:String
    let description:String
    let icon:String
}

struct Coordinates:Codable {
    let lon:Double
    let lat:Double
}

struct WeatherCurrent:Codable {
    let coord:Coordinates
}

