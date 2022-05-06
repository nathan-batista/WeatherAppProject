//
//  TodayWeather+TableExtension.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 28/04/22.
//

import Foundation
import UIKit

extension TodayWeatherViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fields.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayWeatherTableViewCell.identifier) as! TodayWeatherTableViewCell
        let field = fields[indexPath.row]
        var data:String = "Erro"
        if let safeWeather = todayWeather{
            switch(field){
            case .temp_max:
                data = "\(Int(safeWeather.temp.max))ºC"
                break
            case .feels_like:
                data = "\(Int(safeWeather.feels_like.day))ºC"
                break
            case .humidity:
                data = "\(safeWeather.humidity)º%"
                break
            case .pressure:
                data = "\(safeWeather.pressure)hPA"
                break
            case .temp_min:
                data = "\(Int(safeWeather.temp.min))ºC"
                break
            }
        }
        cell.configure2(model: data, field: field)
        cell.selectionStyle = .none
        return cell
    }
}

