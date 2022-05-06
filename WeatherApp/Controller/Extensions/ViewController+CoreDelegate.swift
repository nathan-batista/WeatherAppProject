//
//  ViewController+CoreDelegate.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import Foundation
import UIKit

extension ViewController {
 
    func reloadLabels() {
        let weather = weatherManager.getWeatherList()
        if let safeWeather = weather?.daily[0]{
            self.tempLabel.text = "\(Int(safeWeather.temp.day))ºC"
            let imageName = ImageGetter.getImage(safeWeather.weather[0])
            weatherImage.image = UIImage(systemName: imageName)?.withTintColor(.label, renderingMode: .alwaysOriginal)
            self.navigationItem.title = "\(safeWeather.weather[0].main)"
        }
    }
}
