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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let date = Date(timeIntervalSince1970: day["dt"].doubleValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM HH:mm"
        let str = dateFormatter.string(from: date)
        cell.dayDate.text = str
        
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        
        let temp = Measurement(value: day["main"]["temp"].doubleValue, unit: UnitTemperature.celsius)
        cell.dayTemperature.text = formatter.string(from: temp)
        
        let iconCode = day["weather"][0]["icon"].stringValue
        
        
        Alamofire.request("https://openweathermap.org/img/wn/\(iconCode)@2x.png")
            .validate(statusCode: 200..<300)
            .response(completionHandler: ({ (response) in
                if let data = response.data {
                    cell.dayImage.image = UIImage(data: data, scale: 1)
                }
                
            }))
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
