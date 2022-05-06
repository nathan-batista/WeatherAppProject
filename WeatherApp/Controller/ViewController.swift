//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, ChooseCity {
    func didSelectCity(city: String) {
        print(city)
        WeatherService.requestTempForCity(city: city.lowercased(), manager: self.locationManager){
            weather in
                self.weather = weather
                DispatchQueue.main.async {
                    self.reloadLabels()
                    self.tempTable.reloadData()
                }
        }
    }
    
   
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempTable: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let locationManager : CLLocationManager = CLLocationManager()
    
    var coordinates : CLLocation?
    
    var weather: WeatherList?
    
    var resultadosBusca:CidadesTableViewController?
    
    let APIController = API()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
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
        
        resultadosBusca = CidadesTableViewController()
        resultadosBusca?.delegate = self
        

        // Do any additional setup after loading the view.
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTodayWeather" {
            if let destination = segue.destination as? TodayWeatherViewController,
                let index = sender as? IndexPath{
                let date = DateGetter.getCurrentDate()
                let day = (date?[0] ?? 0) + index.row
                destination.title = "Day \(day)"
                destination.todayWeather = weather?.daily[index.row]
            }
        }
    }
    
    
    @IBAction func tappedSearch(_ sender: Any) {
        if let safeText = searchTextField.text?.lowercased() {
            print(safeText)
            searchTextField.endEditing(true)
        }
    }
}



