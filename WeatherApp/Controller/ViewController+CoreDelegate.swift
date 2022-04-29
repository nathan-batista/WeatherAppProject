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
        if WeatherService.verifyHasLocation(locations: locations, coordinates: coordinates) {
            coordinates = locations.first
            WeatherService.makeRequest(coordinates: coordinates!, manager: manager, APIController: APIController){ [weak self] weatherResponse in
                self?.weather = weatherResponse
                DispatchQueue.main.async {
                    self?.reloadLabels()
                }
            }
        }
    }
    
    func reloadLabels() {
        self.tempLabel.text = "\(Int(weather!.main.temp))º"
        self.sensacaoLabel.text = "\(Int(weather!.main.temp))º"
        self.minTempLabel.text = "\(Int(weather!.main.temp_min))º"
        self.maxTemplabel.text = "\(Int(weather!.main.temp_max))º"
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
