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
   
    
    @IBAction func refreshDataButton(_ sender: UIBarButtonItem) {
        weatherService.loadWeatherForecast(cityName: cityName) {(weathers, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let weathers = weathers else {return}
            DataBaseService.saveToRealm(items: weathers, config: DataBaseService.configuration, update: true)
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
