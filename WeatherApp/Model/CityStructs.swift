//
//  CityStructs.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 04/05/22.
//


struct City:Codable,Hashable, Equatable {
    let Key:String
    let `Type`:String
    let LocalizedName:String
    
    var hashValue: Int {
        return Key.hashValue
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        return
        lhs.LocalizedName == rhs.LocalizedName
    }
}

