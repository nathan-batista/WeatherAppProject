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
    
    
    //Criar classe de localização
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    //Passar a requisicao da API para um WeatherService e mudar a verificação do location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        WeatherService.callAPI(locations: locations, coordinates: &coordinates, manager: manager) { weatherResponse in
            self.weather = weatherResponse
            DispatchQueue.main.async {
                self.reloadLabels()
                self.tempTable.reloadData()
            }
        }
    }
    
    func reloadLabels() {
        if let weather = weather?.daily[0]{
            self.tempLabel.text = "\(Int(weather.temp.day))ºC"
            let imageName = ImageGetter.getImage(weather.weather[0])
            weatherImage.image = UIImage(systemName: imageName)?.withTintColor(.label, renderingMode: .alwaysOriginal)
            self.navigationItem.title = "\(weather.weather[0].main)"
        }
    }
}
