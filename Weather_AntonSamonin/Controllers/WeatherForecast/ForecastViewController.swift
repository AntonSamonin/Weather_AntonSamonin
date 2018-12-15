//
//  ForecastViewController.swift
//  Weather_AntonSamonin
//
//  Created by Anton Samonin on 12/4/18.
//  Copyright © 2018 AntCo. All rights reserved.
//

import UIKit
import RealmSwift

class ForecastViewController: UIViewController {
    
    private var weatherForecast: Results<Weather>?
    private var notificationToken: NotificationToken?
    private var todayDateStr = currentDate()
    private var daysOfTheWeek = [[Weather]]()
    
    
    @IBOutlet weak var forecastTableView: UITableView!{
        didSet {
            self.forecastTableView.clipsToBounds = true
            self.forecastTableView.layer.cornerRadius = 16
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTableView.register(UINib(nibName: "WeatherForecastCell", bundle: nil), forCellReuseIdentifier: "ForecastCell")
        forecastTableView.estimatedRowHeight = 44
        forecastTableView.rowHeight = UITableView.automaticDimension
        
        
        self.weatherForecast = DataBaseService.get(itemsType: Weather.self, config: Realm.Configuration.defaultConfiguration)?.filter("dayOfTheWeek != '\(todayDateStr)'")
        
        self.sortedDays()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.notificationToken = weatherForecast?.observe{[weak self]  changes in
            guard let self = self else {return}
            switch changes {
                
            case .initial(_):
                self.forecastTableView.reloadData()
                print("Подписался на weatherForecast")
            case .update(_):
                self.daysOfTheWeek = [[Weather]]()
                self.sortedDays()
                self.forecastTableView.reloadData()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
        print("Отписался от обновлений weatherForecast")
    }
    
    
    
    private func sortedDays() {
        
        var dayIndex = 0
        guard let weatherForecast = weatherForecast else {return}
        for day in weatherForecast.enumerated() {
            
            guard !daysOfTheWeek.isEmpty else {
                daysOfTheWeek.append([day.element])
                continue
            }
            let currentDay = day.element.dayOfTheWeek
            let previousDay = weatherForecast[day.offset-1].dayOfTheWeek
            
            
            if currentDay == previousDay {
                daysOfTheWeek[dayIndex].append(day.element)
            }
            else {
                dayIndex += 1
                daysOfTheWeek.append([day.element])
            }
        }
    }
    
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        
        
        cell.configure(with: daysOfTheWeek[indexPath.section][4])
        cell.nightTempLabel.text = String(format: "%.0f℃", daysOfTheWeek[indexPath.section][0].tempreture)
        cell.morningTempLabel.text = String(format: "%.0f℃", daysOfTheWeek[indexPath.section][2].tempreture)
        cell.afternoonTempLabel.text = String(format: "%.0f℃", daysOfTheWeek[indexPath.section][4].tempreture)
        cell.eveningTempLabel.text = String(format: "%.0f℃", daysOfTheWeek[indexPath.section][6].tempreture)
        
        
        return cell
        
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
    //        let dayOfTheWeek = dateFormatter(weather: daysOfTheWeek[section][0], format: "EEEE MMMM d")
    //        header.headerLabel.text = dayOfTheWeek
    //        return header
    //    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let weekDay = daysOfTheWeek[section][0].dayOfTheWeek
        return weekDay
    }
    
    static func currentDate() -> String {
        var today = Date()
        var dateFormatter: DateFormatter {
            let dt = DateFormatter()
            dt.dateFormat = "EEEE dd MMMM"
            dt.timeZone = TimeZone.current
            dt.locale = Locale(identifier: "ru_RU")
            return dt
        }
        return dateFormatter.string(from: today )
    }
    
    
}



