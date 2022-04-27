//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 03/04/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let size = (weather?.list.count ?? 0)/8
        return size
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DateTempTableViewCell.identifier) as! DateTempTableViewCell
        var date = DateGetter().getCurrentDate()
        let day = date?[0] ?? 0
        date?[0] = day + indexPath.row
        cell.configure(date ?? [0], model: weather?.list[indexPath.row*8])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DateTempTableViewCell
        for view in cell.tempStack.arrangedSubviews{
            let newView = view as! UILabel
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
    
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

    
    
    

}



