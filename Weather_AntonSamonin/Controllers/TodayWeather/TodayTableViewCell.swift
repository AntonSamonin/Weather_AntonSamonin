//
//  TodayTableViewCell.swift
//  Weather_AntonSamonin
//
//  Created by Anton Samonin on 11/24/18.
//  Copyright © 2018 AntCo. All rights reserved.
//

import UIKit
import Kingfisher
class TodayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tempretureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var timeLable: UILabel!
    
    
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
    //    "EEEE, HH:mm"
    func configure(with weather: Weather) {
        let date = Date(timeIntervalSince1970: Double(weather.date))
        self.timeLable.text = dateFormatter.string(from: date)
        self.tempretureLabel.text = String(format: "%.0f℃", weather.tempreture)
        self.weatherIcon.kf.setImage(with: WeatherService.urlForWeatherIcon(weather.weatherIcon))
    }
    
    override func prepareForReuse() {
        self.timeLable.text = nil
        self.tempretureLabel.text = nil
        self.weatherIcon.image = nil
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
