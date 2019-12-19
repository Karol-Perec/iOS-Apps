//
//  LongTermWeatherTableViewController.swift
//  Lab1
//
//  Created by Karol Perec on 18/12/2019.
//  Copyright © 2019 Karol Perec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LongTermWeatherTableViewController: UITableViewController {
    var days = JSON()
    var timezone = Double()
    let formatter = MeasurementFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.numberFormatter.maximumFractionDigits = 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LongTermWeatherTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LongTermWeatherTableViewCell
        let day = days["list"][indexPath.row]
        
        let date = Date(timeIntervalSince1970: day["dt"].doubleValue + timezone)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM HH:mm"
        cell.dayDate.text = dateFormatter.string(from: date)
        
        let temp = Measurement(value: day["main"]["temp"].doubleValue, unit: UnitTemperature.celsius)
        cell.dayTemperature.text = formatter.string(from: temp)
        
        cell.dayImage.image = UIImage(named: day["weather"][0]["icon"].stringValue)
        
        cell.humidity.text = "Humidity: \(day["main"]["humidity"].stringValue)%"
        cell.wind.text = "Wind: \(day["wind"]["speed"].intValue) m/s"

        return cell
    }
}
