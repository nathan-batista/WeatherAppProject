//
//  ViewController+TextFieldDelegate.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 04/05/22.
//

import UIKit

extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var cidades:[City]?
        if let safeText = textField.text?.lowercased(){
            print(safeText)
            self.view.endEditing(true)
            WeatherService.requestForCities(city: safeText) { cities in
                guard let safeCidades = cities else {return}
                cidades = safeCidades.filter{$0.`Type`.lowercased() == "city"}
                DispatchQueue.main.async {
                    self.resultadosBusca?.cities = cidades!
                    self.navigationItem.backButtonTitle = "Voltar"
                    self.resultadosBusca?.tableView.reloadData()
                    self.navigationController?.pushViewController(self.resultadosBusca!, animated: true)
                }
            }
            return true
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
}
