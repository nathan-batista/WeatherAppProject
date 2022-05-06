//
//  CitiesTableViewCell.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 04/05/22.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {
    
    static let identifier = "CitiesTableViewCell"

    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model:City) {
        cityNameLabel.text = model.LocalizedName
    }
    
}
