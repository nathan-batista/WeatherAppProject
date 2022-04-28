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
           
          
//            let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=bd9d9e36d84edc52956d87da343a9e96&units=metric&lang=pt_br"
            APIController.tempRequest(Float(coordinates!.coordinate.latitude),Float(coordinates!.coordinate.longitude)){ [weak self] weatherResponse in
                self?.weather = weatherResponse
                DispatchQueue.main.async {
                    self?.reloadLabels()
                    self?.tempTable.reloadData()
                }
            }
        }
    }
    
    func reloadLabels() {
//        self.sensacaoLabel.text = "\(weather!.main.temp)º"
//        self.minTempLabel.text = "\(weather!.main.temp_min)º"
//        self.maxTemplabel.text = "\(weather!.main.temp_max)º"
//        self.pressureLabel.text = "\(weather!.main.pressure)hPa"
//        self.humidityLabel.text = "\(weather!.main.humidity)%"
        if let weather = weather?.list[0]{
            self.tempLabel.text = "\(Int(weather.main.temp))ºC"
            let imageName = ImageGetter().getImage(weather.weather[0])
            weatherImage.image = UIImage(named: imageName)
            self.title = "\(weather.weather[0].main)"
        }
    }
}
