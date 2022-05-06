//
//  TodayWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 27/04/22.
//

import UIKit

class TodayWeatherTableViewCell: UITableViewCell {
    
    static let identifier = "TodayWeatherCell"
    
    @IBOutlet weak var fieldLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //Passar decisao dos fields para o TableViewController
    func configure(model:WeatherAPIDataDay?,field:WeatherFields) {
        if let model = model {
            switch field {
            case .temp_max:
                fieldLabel.text = "Temp. Máx:"
                valueLabel.text = "\(Int(model.temp.max))ºC"
            case .temp_min:
                fieldLabel.text = "Temp. Min:"
                valueLabel.text = "\(Int(model.temp.min))ºC"
            case .humidity:
                fieldLabel.text = "Umidade:"
                valueLabel.text = "\(model.humidity)%"
            case .feels_like:
                fieldLabel.text = "Sensação Térmica:"
                valueLabel.text = "\(Int(model.feels_like.day))ºC"
            case .pressure:
                fieldLabel.text = "Pressão:"
                valueLabel.text = "\(model.pressure)hPa"
            }
        }
    }
    
}
