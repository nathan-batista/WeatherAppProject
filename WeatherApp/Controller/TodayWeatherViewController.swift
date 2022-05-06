//
//  TodayWeatherViewController.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 27/04/22.
//

import UIKit

class TodayWeatherViewController: UIViewController {
    var fields = [WeatherFields.temp_max,
                  WeatherFields.temp_min,
                  WeatherFields.feels_like,
                  WeatherFields.humidity,
                  WeatherFields.pressure
    ]
    
    @IBOutlet weak var todayTable:UITableView!
    @IBOutlet weak var temp:UILabel!
    @IBOutlet weak var todayImage:UIImageView!
    
    var todayWeather:WeatherAPIDataDay?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup do delegate da table e arredondamento de bordas
        todayTable.dataSource = self
        todayTable.delegate = self
        todayTable.layer.cornerRadius = 15
        todayTable.tableFooterView = UIView()
        //registro da célula do xib na table
        todayTable.register(UINib(nibName: "TodayWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: TodayWeatherTableViewCell.identifier)
        //Obter a imagem que irá para a view
        if let weather = todayWeather {
            temp.text = "\(Int(weather.temp.day))ºC"
            let imageName = ImageGetter.getImage(weather.weather[0])
            todayImage.image = UIImage(systemName: imageName)?.withTintColor(.label, renderingMode: .alwaysOriginal)
        }
        
        // Do any additional setup after loading the view.
    }
    
}
