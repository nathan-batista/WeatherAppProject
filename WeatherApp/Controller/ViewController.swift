//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
        
   
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempTable: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let weatherManager = WeatherService()
    var weather:WeatherList?
        
    var resultadosBusca:CidadesTableViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        tempTable.dataSource = self
        tempTable.delegate = self
        weatherManager.delegate = self
        //Registra o xib da celula na tabela
        tempTable.register(UINib(nibName: DateTempTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DateTempTableViewCell.identifier)
        weatherManager.setup(delegate: self)
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

extension ViewController:ChooseCity {
    func didSelectCity(city: String) {
        print(city)
        weatherManager.selectedTempCity(city:city)
    }
}

extension ViewController:updatedData {
    func citiesFound(cidades:[City]) {
        self.resultadosBusca?.cities = cidades
        self.navigationItem.backButtonTitle = "Voltar"
        self.resultadosBusca?.tableView.reloadData()
        self.navigationController?.pushViewController(self.resultadosBusca!, animated: true)
    }
    
    func didUpdateWeather() {
        self.weather = weatherManager.getWeatherList()
        self.reloadLabels()
        self.tempTable.reloadData()
    }
}

extension ViewController:didUpdateLocation{
    func newLocationFound() {
        weatherManager.requestWeather()
    }
    
    
}



