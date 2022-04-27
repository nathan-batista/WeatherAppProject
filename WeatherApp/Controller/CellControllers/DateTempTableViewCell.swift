//
//  DateTempTableViewCell.swift
//  WeatherApp
//
//  Created by Nathan Batista de Oliveira on 27/04/22.
//

import UIKit

class DateTempTableViewCell: UITableViewCell {
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var dayLabel:UILabel!
    @IBOutlet weak var tempStack:UIStackView!
    
    static let identifier = "DateTempTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(_ date:[Int], model:WeatherAPIData?) {
        dayLabel.text = "\(date[0])"
        if let model = model {
            let imageName = ImageGetter().getImage(model.weather[0])
            tempImageView.image = UIImage(named: imageName)
            for view in tempStack.arrangedSubviews {
              let labelView = view as! UILabel
                switch labelView.tag{
                    case 0:
                    labelView.text =  String(Int(model.main.temp_min))+"ºC"
                    default:
                    labelView.text = String(Int(model.main.temp_max))+"ºC"
                }
            }
        }
    }
    
}
