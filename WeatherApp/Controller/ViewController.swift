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
    @IBOutlet weak var sensacaoLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTemplabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    let locationManager : CLLocationManager = CLLocationManager()
    
    var coordinates : CLLocation?
    
    var weather: WeatherAPIData?
    
    let APIController = API()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        // Do any additional setup after loading the view.
    }


}



