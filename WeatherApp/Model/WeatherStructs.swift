//
//  WeatherStructs.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import Foundation

struct WeatherList:Codable {
    let cod:String
    let message:Int
    let cnt:Int
    let list:[WeatherAPIData]
    let country:String?
    let population:Int?
    let timezone:Int?
    let sunrise:Int?
    let sunset:Int?
}


struct WeatherAPIData:Codable{
    let dt:Int
    let main:MainData
    let weather:[Weather]
    let clouds:Clouds
    let wind:WindStatus
    let visibility:Int
    let pop:Float
    let sys:SysDataAPI
    let dt_txt:String
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
