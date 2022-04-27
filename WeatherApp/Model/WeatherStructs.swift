//
//  WeatherStructs.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import Foundation



struct WeatherAPIData:Codable{
    let coord:Coordinates
    let weather:[Weather]
    let base:String
    let main:MainData
    let visibility:Int
    let wind:WindStatus
    let clouds:Clouds
    let dt:Int
    let sys:SysData
    let timezone:Int
    let id:Int
    let name:String
    let cod:Int
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
    let humidity:Int
}

struct WindStatus : Codable {
    let speed:Float
    let deg:Int
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
