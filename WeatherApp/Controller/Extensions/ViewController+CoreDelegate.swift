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
    
    //Passar a requisicao da API para um WeatherService e mudar a verificação do location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if WeatherService.verifyHasLocation(locations: locations, coordinates: coordinates){
            coordinates = locations.first
            WeatherService.makeRequest(coordinates: coordinates!, manager: locationManager, APIController: APIController){ [weak self] weatherResponse in
                self?.weather = weatherResponse
                DispatchQueue.main.async {
                    self?.reloadLabels()
                    self?.tempTable.reloadData()
                }
            }
        }
    }
    
    func reloadLabels() {
        if let weather = weather?.list[0]{
            self.tempLabel.text = "\(Int(weather.main.temp))ºC"
            let imageName = ImageGetter().getImage(weather.weather[0])
            weatherImage.image = UIImage(named: imageName)
            self.title = "\(weather.weather[0].main)"
        }
    }
}
