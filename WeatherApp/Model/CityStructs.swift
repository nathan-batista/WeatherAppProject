//
//  CityStructs.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 04/05/22.
//


struct City:Codable,Equatable{
    let Key:String
    let `Type`:String
    let LocalizedName:String
    
    static func == (lhs: City, rhs: City) -> Bool {
        return
        lhs.LocalizedName == rhs.LocalizedName
    }
}

