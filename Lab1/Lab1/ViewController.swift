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
import SwiftLocation

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
    var longTermWeather = JSON()
    var locationManager: LocationManager!
    let formatter = MeasurementFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.numberFormatter.maximumFractionDigits = 0
        setElementsUnvisible(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mainVCtoTableVC"){
            let tableVC = segue.destination as! LongTermWeatherTableViewController
            tableVC.days = longTermWeather
        }
    }
    @IBAction func location(_ sender: UIButton) {
        let req = LocationManager.shared.locateFromGPS(.oneShot, accuracy: .city) { result in switch result {
            case .failure(let error):
                debugPrint("Received error: \(error)")
            case .success(let location):
                debugPrint("Location received: \(location)")
                Alamofire.request(self.currentWeatherUrl, parameters: ["lat": location.coordinate.latitude, "lon": location.coordinate.longitude, "APPID": self.appId, "units": "metric"])
                    .validate(statusCode: 200..<300)
                    .responseJSON { (response) in
                        if let data = response.value {
                            self.setWeather(JSON(data))
                        }
                }
            }
            
        }
    }

    @IBAction func search(_ sender: UIButton) {
        Alamofire.request(currentWeatherUrl, parameters: ["q": searchField.text!, "APPID": appId, "units": "metric"])
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                if let data = response.value {
                    self.setWeather(JSON(data))
                }
        }
        searchField.text = ""
    }
    
    func setWeather(_ data: JSON) -> Void {
        self.cityName.text = data["name"].stringValue
    
        self.temperature.text = getTemperature(data["main"]["temp"].doubleValue)
        
        self.minTemperature.text = getTemperature(data["main"]["temp_min"].doubleValue)
        
        self.maxTemperature.text = getTemperature(data["main"]["temp_max"].doubleValue)
        
        let iconCode = data["weather"][0]["icon"].stringValue
        Alamofire.request("https://openweathermap.org/img/wn/\(iconCode)@2x.png")
            .validate(statusCode: 200..<300)
            .response(completionHandler: ({ (response) in
                if let data = response.data {
                    self.weatherImage.image = UIImage(data: data, scale: 1)
                }
            }))
        
        self.weatherDescripiton.text = data["weather"][0]["description"].stringValue
        
        Alamofire.request(self.longTermWeatherUrl, parameters: ["id": data["id"].stringValue, "APPID": self.appId, "units": "metric"])
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                if let data = response.value {
                    self.longTermWeather = JSON(data)
                }
        }
        
       setElementsUnvisible(False)
    }
    
    func getTemperature(_ measurement: Double) -> String {
        let temp = Measurement(value: measurement, unit: UnitTemperature.celsius)
        return formatter.string(from: temp)
    }
    
    func setElementsUnvisible(_ isHidden: Bool) -> Void {
        minTemperature.isHidden = isHidden
        maxTemperature.isHidden = isHidden
        temperature.isHidden = isHidden
        weatherImage.isHidden = isHidden
        weatherDescripiton.isHidden = isHidden
    }
}
