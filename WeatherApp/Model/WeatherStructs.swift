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

struct Coordinates : Codable {
    let lon:Float
    let lat:Float
}

struct Weather : Codable {
    let id:Int
    let main:String
    let description:String
    let icon:String
}

struct MainData : Codable{
    let temp:Float
    let feels_like:Float
    let temp_min:Float
    let temp_max:Float
    let pressure:Int
    let sea_level:Int
    let grnd_level:Int
    let humidity:Int
    let temp_kf:Float
}

struct WindStatus : Codable {
    let speed:Float
    let deg:Int
    let gust:Float
}

struct Clouds : Codable {
    let all:Int
}

struct SysData : Codable {
    let type:Int
    let id:Int
    let message:Float?
    let country:String
    let sunrise:Int
    let sunset:Int
}

struct SysDataAPI:Codable {
    let pod:String
}
