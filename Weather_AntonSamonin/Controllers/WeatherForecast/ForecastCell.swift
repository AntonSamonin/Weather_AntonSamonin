//
//  WeatheForecastCell.swift
//  Weather_AntonSamonin
//
//  Created by Anton Samonin on 11/24/18.
//  Copyright © 2018 AntCo. All rights reserved.
//

import UIKit
import Kingfisher
class ForecastCell: UITableViewCell {
    
    @IBOutlet weak var forecastContentView: UIView!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var morningTempLabel: UILabel!
    @IBOutlet weak var afternoonTempLabel: UILabel!
    @IBOutlet weak var eveningTempLabel: UILabel!
    @IBOutlet weak var visualEffectView: UIView!
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    private var dateFormatter: DateFormatter {
        let dt = DateFormatter()
        dt.dateFormat = "HH:mm"
        dt.timeZone = TimeZone.current
        return dt
    }
    
    override func layoutIfNeeded() { // Закругление
        super .layoutIfNeeded()
        //        self.visualEffectView.clipsToBounds = true
        //        self.visualEffectView.layer.cornerRadius = 16
    }
    
    
    func configure(with weather: Weather) {
        self.weatherIcon.kf.setImage(with: WeatherService.urlForWeatherIcon(weather.weatherIcon))
        self.pressureLabel.text = String("\(weather.pressure) мм рт. ст.")
        self.windLabel.text = String("\(weather.wind) м/с")
        self.humidityLabel.text = String("\(weather.humidity) %")
        
    }
    
    override func prepareForReuse() {
        self.pressureLabel.text = nil
        self.windLabel.text = nil
        self.weatherIcon.image = nil
        self.humidityLabel.text = nil
        self.nightTempLabel.text = nil
        self.morningTempLabel.text = nil
        self.afternoonTempLabel.text = nil
        self.eveningTempLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
