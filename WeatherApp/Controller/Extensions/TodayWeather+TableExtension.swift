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
        cell.configure(model: todayWeather, field: fields[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

