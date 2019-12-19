//
//  ViewController.swift
//  Lab1
//
//  Created by Karol Perec on 12/12/2019.
//  Copyright © 2019 Karol Perec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var weatherDescripiton: UILabel!
    
    let appId = "fb68fb31212518fa986c58366250f021"
    let currentWeatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    let longTermWeatherUrl = "https://api.openweathermap.org/data/2.5/forecast"
    var cityId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mainVCtoTableVC"){
            debugPrint("111121544")
            let tableVC = segue.destination as! LongTermWeatherTableViewController
            Alamofire.request(longTermWeatherUrl, parameters: ["id": self.cityId, "APPID": appId, "units": "metric"])
                .responseJSON { (response) in
                    tableVC.days = JSON(response.value!)
            }
        }
    }

    @IBAction func longTermWeatherButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mainVCtoTableVC", sender: self)
        debugPrint("XDDDDD")
    }
    
    @IBOutlet weak var weather: UIStackView!
    @IBAction func search(_ sender: UIButton) {
        Alamofire.request(currentWeatherUrl, parameters: ["q": searchField.text!, "APPID": appId, "units": "metric"])
            .responseJSON { (response) in
                let data = JSON(response.value!)
                self.cityName.text = data["name"].stringValue
                
                let formatter = MeasurementFormatter()
                formatter.numberFormatter.maximumFractionDigits = 0
                
                let temp = Measurement(value: data["main"]["temp"].doubleValue, unit: UnitTemperature.celsius)
                self.temperature.text = formatter.string(from: temp)
                
                let minTemp = Measurement(value: data["main"]["temp_min"].doubleValue, unit: UnitTemperature.celsius)
                self.minTemperature.text = formatter.string(from: minTemp)
                
                let maxTemp = Measurement(value: data["main"]["temp_max"].doubleValue, unit: UnitTemperature.celsius)
                self.maxTemperature.text = formatter.string(from: maxTemp)
                
                let iconCode = data["weather"][0]["icon"].stringValue
                Alamofire.request("https://openweathermap.org/img/wn/\(iconCode)@2x.png")
                    .response(completionHandler: ({ (response) in
                        self.weatherImage.image = UIImage(data: response.data!, scale: 1)
                    }))
                
                self.weatherDescripiton.text = data["weather"][0]["description"].stringValue
                
                self.cityId = data["id"].stringValue
            }
        }
}
