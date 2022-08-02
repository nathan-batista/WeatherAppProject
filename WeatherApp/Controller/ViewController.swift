//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import UIKit
import CoreLocation
import Combine

class ViewController: UIViewController{
    
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempTable: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let weatherManager = WeatherService()
    var weather:WeatherList?
    var cancellables = Set<AnyCancellable>()
    
    var resultadosBusca:CidadesTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        tempTable.dataSource = self
        tempTable.delegate = self
        //Registra o xib da celula na tabela
        tempTable.register(UINib(nibName: DateTempTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DateTempTableViewCell.identifier)
        //setup de borda
        tempTable.layer.cornerRadius = 15
        //Remover a celula vazia no fim da tabela
        tempTable.tableFooterView = UIView()
        //Tamanho automatico da celula
        tempTable.rowHeight = UITableView.automaticDimension
        tempTable.estimatedRowHeight = 70
        
        //Após obter a ultima promise da cadeia de promises eu atualizo os dados e a view
        weatherManager.$weatherList
            .sink(receiveValue: { weather in
                if let safeWeather = weather {
                    DispatchQueue.main.async {
                        self.weather = safeWeather
                        self.reloadLabels()
                        self.tempTable.reloadData()
                    }
                }
            })
            .store(in: &cancellables)
        
        
//        weatherManager.requestWeatherCurrentLocation()
//            .done(on: DispatchQueue.main, flags: nil) { weather in
//                self.weather = weather
//                self.tempTable.reloadData()
//                self.reloadLabels()
//                self.weatherManager.getCityNameForCurrentLocation()
//                    .done(on: DispatchQueue.main, flags: nil){ name in
//                        self.title = name
//                    }
//                    .catch{ error in
//                        print(error)
//                    }
//            }
//            .catch{ error in
//                print(error)
//            }
        
        
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
            //Após receber as cidades atualizo a view q irei navegar
            weatherManager.requestForCity(city: safeText)
                .catch({ error -> Just<[City]> in
                    print(error)
                    return Just([])
                })
                .sink(receiveValue: { cities in
                    if let cidadesController = self.resultadosBusca {
                        if !cities.isEmpty {
                            self.resultadosBusca?.cities = cities
                            self.navigationItem.backButtonTitle = "Voltar"
                            self.resultadosBusca?.tableView.reloadData()
                            self.navigationController?.pushViewController(cidadesController, animated: true)
                        }
                    }
                })
            
            
//            weatherManager.requestForCity(city: safeText).done(on: DispatchQueue.main, flags: nil) { cities in
//                if let cidadesController = self.resultadosBusca {
//                    self.resultadosBusca?.cities = cities
//                    self.navigationItem.backButtonTitle = "Voltar"
//                    self.resultadosBusca?.tableView.reloadData()
//                    self.navigationController?.pushViewController(cidadesController, animated: true)
//                }
//            }
        }
    }
}

extension ViewController:ChooseCity {
    func didSelectCity(city: String) {
        print(city)
        //Após receber a temperatura da cidade escolhida irei atualizar os dados
        weatherManager.selectedTempCity(city: city.lowercased())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { list in
                self.weather = list
                self.tempTable.reloadData()
                self.reloadLabels()
                self.title = city
            }
            .store(in: &cancellables)

            
        
        
//        weatherManager.selectedTempCity(city:city.lowercased()).done(on: DispatchQueue.main, flags: nil) { list in
//            self.weather = list
//            self.tempTable.reloadData()
//            self.reloadLabels()
//            self.title = city
//        }
    }
}





