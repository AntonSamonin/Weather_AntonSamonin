//
//  TabBarController.swift
//  Weather_AntonSamonin
//
//  Created by Anton Samonin on 12/11/18.
//  Copyright © 2018 AntCo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    private var cityName = "Samara"
    private var weatherService = WeatherService()
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    
    @IBAction func refreshDataButton(_ sender: UIBarButtonItem) {
        refreshButton.isEnabled = false
        weatherService.loadWeatherForecast(cityName: cityName) {(weathers, error) in
            if let error = error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Отсутствует подключение к интернету.", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.refreshButton.isEnabled = true
                return
            }
            guard let weathers = weathers else {return}
            DataBaseService.saveToRealm(items: weathers, config: DataBaseService.configuration, update: true)
            self.refreshButton.isEnabled = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
