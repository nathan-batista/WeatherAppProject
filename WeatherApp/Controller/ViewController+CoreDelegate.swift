//
//  ViewController+CoreDelegate.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import Foundation
import UIKit
import CoreLocation

extension ViewController : CLLocationManagerDelegate {
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty && coordinates == nil {
            coordinates = locations.first
            locationManager.stopUpdatingLocation()
            let lat = String(format: "%.2f", coordinates!.coordinate.latitude)
            let lon = String(format: "%.2f", coordinates!.coordinate.longitude)
            let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=bd9d9e36d84edc52956d87da343a9e96&units=metric&lang=pt_br"
            APIController.request(url){ [weak self] weatherResponse in
                self?.weather = weatherResponse
                DispatchQueue.main.async {
                    self?.reloadLabels()
                }
            }
        }
    }
    
    func reloadLabels() {
        self.tempLabel.text = "\(weather!.main.temp)º"
        self.sensacaoLabel.text = "\(weather!.main.temp)º"
        self.minTempLabel.text = "\(weather!.main.temp_min)º"
        self.maxTemplabel.text = "\(weather!.main.temp_max)º"
        self.pressureLabel.text = "\(weather!.main.pressure)hPa"
        self.humidityLabel.text = "\(weather!.main.humidity)%"
        self.title = "\(weather!.name)"
        
        var imageName = ""
        if weather!.weather[0].main.lowercased() == "clear" {
            imageName = "clear"
        }
        else if weather!.weather[0].main.lowercased() == "clouds" {
            imageName = "clouds"
        }
        else {
            imageName = "sun"
        }
        weatherImage.image = UIImage(named: imageName)
    }
}
