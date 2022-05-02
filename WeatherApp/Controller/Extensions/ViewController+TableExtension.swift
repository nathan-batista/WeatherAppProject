//
//  ViewController+TableExtension.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 28/04/22.
//

import Foundation
import UIKit

extension ViewController:UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let size = weather?.daily.count
        return size ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DateTempTableViewCell.identifier) as! DateTempTableViewCell
        var date = DateGetter().getCurrentDate()
        let day = date?[0] ?? 0
        date?[0] = day + indexPath.row
        cell.configure(date ?? [0], model: weather?.daily[indexPath.row])
        //Remover background cinza quando selecionado
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DateTempTableViewCell
        performSegue(withIdentifier: "goToTodayWeather", sender: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
