//
//  ViewController+TextFieldDelegate.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 04/05/22.
//

import UIKit

extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let safeText = textField.text?.lowercased().replacingOccurrences(of: " ", with: "&"){
            print(safeText)
            self.view.endEditing(true)
            weatherManager.requestForCity(city: safeText,delegate: self)
            return true
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
}
