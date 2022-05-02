//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
   
   
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempTable: UITableView!
    
    let locationManager : CLLocationManager = CLLocationManager()
    
    var coordinates : CLLocation?
    
    var weather: WeatherList?
    
    let APIController = API()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempTable.dataSource = self
        tempTable.delegate = self
        //Registra o xib da celula na tabela
        tempTable.register(UINib(nibName: DateTempTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DateTempTableViewCell.identifier)
        setupLocation()
        //setup de borda
        tempTable.layer.cornerRadius = 15
        //Remover a celula vazia no fim da tabela
        tempTable.tableFooterView = UIView()
        //Tamanho automatico da celula
        tempTable.rowHeight = UITableView.automaticDimension
        tempTable.estimatedRowHeight = 70
        
        

        // Do any additional setup after loading the view.
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTodayWeather" {
            if let destination = segue.destination as? TodayWeatherViewController,
                let index = sender as? IndexPath{
                let date = DateGetter().getCurrentDate()
                let day = (date?[0] ?? 0) + index.row
                destination.title = "Day \(day)"
                destination.todayWeather = weather?.daily[index.row]
            }
        }
    }
    
    
    

}



