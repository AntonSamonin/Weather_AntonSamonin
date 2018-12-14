//
//  TodayWeatherController.swift
//  Weather_AntonSamonin
//
//  Created by Anton Samonin on 11/27/18.
//  Copyright © 2018 AntCo. All rights reserved.
//

import UIKit
import RealmSwift


class TodayWeatherController: UIViewController {
    
    
    private var weatherService = WeatherService()
    private var cityName = "Samara"
    private var notificationToken: NotificationToken?
    private var todayWeather: Results<Weather>?
    private var todayDateStr = currentDate()
    
    
    @IBOutlet weak var weatherTableView: UITableView! {
        didSet {
            self.weatherTableView.clipsToBounds = true
            self.weatherTableView.layer.cornerRadius = 16
        }
    }
    
    @IBOutlet weak var visualEffectView: UIView! {
        didSet {
            self.visualEffectView.clipsToBounds = true
            self.visualEffectView.layer.cornerRadius = 16
        }
    }
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tabbarItem: UITabBarItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.register(UINib(nibName: "TodayTableViewCell", bundle: nil), forCellReuseIdentifier: "Today Weather Forecast")
        
        weatherService.loadWeatherForecast(cityName: cityName) {(weathers, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let weathers = weathers else {return}
            
            DataBaseService.saveToRealm(items: weathers, config: DataBaseService.configuration, update: true)
        }
        
        do {
            let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration)
            self.todayWeather = realm.objects(Weather.self).filter("dayOfTheWeek == '\(todayDateStr)'")
            
        } catch {return}
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.notificationToken = todayWeather?.observe{[weak self]  changes in
            guard let self = self else {return}
            switch changes {
            case .initial(_):
                do {
                    let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration)
                    if !realm.isEmpty {
                        self.configureTodayWeather()
                        self.weatherTableView.reloadData()
                    }
                } catch {return}
                print("подписался на todayWeather")
            case .update(_, let deletions, let insertions, let modifications):
                self.configureTodayWeather()
                self.weatherTableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    deinit {
        notificationToken?.invalidate()
        print("Отписался от изменений todayWeather")
    }
    
}

extension TodayWeatherController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayWeather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Today Weather Forecast", for: indexPath) as? TodayTableViewCell, let today = todayWeather else {return UITableViewCell()}
        
        cell.configure(with: today[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "  Сегодня"
    }
    
    func configureTodayWeather() {
        if let today = self.todayWeather {
            self.tempLabel.text = String(format: "%.0f℃", today[0].tempreture)
            self.windLabel.text = String("\(today[0].wind) м/с")
            self.pressureLabel.text = String("\(today[0].pressure) мм рт.ст.")
            self.humidityLabel.text = String("\(today[0].humidity) %")
        }
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

