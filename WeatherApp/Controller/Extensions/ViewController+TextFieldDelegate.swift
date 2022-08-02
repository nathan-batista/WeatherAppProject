//
//  ViewController+TextFieldDelegate.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 04/05/22.
//

import UIKit
import Combine

extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let safeText = textField.text?.lowercased(){
            print(safeText)
            self.view.endEditing(true)
            weatherManager.requestForCity(city: safeText)
                .catch({ error -> Just<[City]> in
                    print(error)
                    return Just([])
                })
                .receive(on: DispatchQueue.main)
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
                .store(in: &cancellables)
                        //            weatherManager.requestForCity(city: safeText).done{ cities in
                        //                if let cidadesController = self.resultadosBusca {
                        //                    self.resultadosBusca?.cities = cities
                        //                    self.navigationItem.backButtonTitle = "Voltar"
                        //                    self.resultadosBusca?.tableView.reloadData()
                        //                    self.navigationController?.pushViewController(cidadesController, animated: true)
                        //                }
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
}
