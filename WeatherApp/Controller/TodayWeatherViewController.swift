//
//  TodayWeatherViewController.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 27/04/22.
//

import UIKit

class TodayWeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var fields = [WeatherFields.temp_max,
                  WeatherFields.temp_min,
                  WeatherFields.feels_like,
                  WeatherFields.humidity,
                  WeatherFields.pressure
    ]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayWeatherTableViewCell.identifier) as! TodayWeatherTableViewCell
        cell.configure(model: todayWeather, field: fields[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    @IBOutlet weak var todayTable:UITableView!
    @IBOutlet weak var temp:UILabel!
    @IBOutlet weak var todayImage:UIImageView!
    
    var todayWeather:WeatherAPIData?

    override func viewDidLoad() {
        super.viewDidLoad()
        todayTable.dataSource = self
        todayTable.delegate = self
        todayTable.layer.cornerRadius = 15
        todayTable.tableFooterView = UIView()
        todayTable.register(UINib(nibName: "TodayWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: TodayWeatherTableViewCell.identifier)
        if let weather = todayWeather {
            temp.text = "\(Int(weather.main.temp))ºC"
            let imageName = ImageGetter().getImage(weather.weather[0])
            todayImage.image = UIImage(named: imageName)
        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
