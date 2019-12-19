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
    @IBOutlet weak var longTermWeatherButton: UIButton!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var clouds: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var wind: UILabel!
    
    let appId = "fb68fb31212518fa986c58366250f021"
    let currentWeatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    let longTermWeatherUrl = "https://api.openweathermap.org/data/2.5/forecast"
    var longTermWeather = JSON()
    var timezone = Double()
    var locationManager: LocationManager!
    let formatter = MeasurementFormatter()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.numberFormatter.maximumFractionDigits = 0
        dateFormatter.dateFormat = "HH:mm:ss"
        setElementsUnvisible(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mainVCtoTableVC"){
            let tableVC = segue.destination as! LongTermWeatherTableViewController
            tableVC.days = longTermWeather
            tableVC.timezone = timezone
        }
    }
    @IBAction func location(_ sender: UIButton) {
        LocationManager.shared.locateFromGPS(.oneShot, accuracy: .city) { result in switch result {
            case .failure(let error):
                debugPrint("Received error: \(error)")
            case .success(let location):
                debugPrint("Location received: \(location)")
                Alamofire.request(self.currentWeatherUrl, parameters: ["lat": location.coordinate.latitude, "lon": location.coordinate.longitude, "APPID": self.appId, "units": "metric"])
                    .validate(statusCode: 200..<300)
                    .responseJSON { (response) in
                        if let data = response.value {
                            self.setWeather(JSON(data))
                            debugPrint(data)
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
        self.weatherImage.image = UIImage(named: data["weather"][0]["icon"].stringValue)
        self.weatherDescripiton.text = data["weather"][0]["description"].stringValue
        
        self.timezone = data["timezone"].doubleValue
        let date = Date(timeIntervalSince1970: data["dt"].doubleValue + timezone)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd.MM HH:mm"
        self.currentDate.text = dateFormatter2.string(from: date)
        
        let sunriseDate = Date(timeIntervalSince1970: data["sys"]["sunrise"].doubleValue + timezone)
        sunrise.text = "Sunrise: \(dateFormatter.string(from: sunriseDate))"
        
        let sunsetDate = Date(timeIntervalSince1970: data["sys"]["sunset"].doubleValue + timezone)
        sunset.text = "Sunset: \(dateFormatter.string(from: sunsetDate))"
        
        self.clouds.text = "Clouds: \(data["clouds"]["all"].stringValue)%"
        self.humidity.text = "Humidity: \(data["main"]["humidity"].stringValue)%"
        self.wind.text = "Wind: \(data["wind"]["speed"].stringValue) m/s"
        self.pressure.text = "Pressure: \(data["main"]["pressure"].stringValue) hPa"
        
        setElementsUnvisible(false)
        
        Alamofire.request(self.longTermWeatherUrl, parameters: ["id": data["id"].stringValue, "APPID": self.appId, "units": "metric"])
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                if let longTermData = response.value {
                    self.longTermWeather = JSON(longTermData)
                     debugPrint(longTermData)
                }
        }
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
        cityName.isHidden = isHidden
        longTermWeatherButton.isHidden = isHidden
        sunset.isHidden = isHidden
        sunrise.isHidden = isHidden
        currentDate.isHidden = isHidden
        clouds.isHidden = isHidden
        humidity.isHidden = isHidden
        pressure.isHidden = isHidden
        wind.isHidden = isHidden
        
    }
}
