//
//  ViewController.swift
//  Lab2
//
//  Created by Karol Perec on 12/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    static let numberOfReadings = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func runArchivingTest(_ sender: UIButton) {
        
        let t1 = NSDate()
        generateArchivingData()
        let t2 = NSDate()
        print("Generation time: \(t2.timeIntervalSince(t1 as Date))")

//        guard let data2 = NSKeyedUnarchiver.unarchiveObject(withFile: Sensor.ArchiveURL.path) as? [Sensor] else {
//            fatalError("Cannot read data")
//        }
//
//        for sensor in data2 {
//            print(sensor.name + sensor.desc)
//        }
        
//        for reading1 in readings {
//            print("\(reading1.timestamp) \(reading1.sensor.name)\(reading1.sensor.desc) \(reading1.value)")
//        }
    }
    
    func generateArchivingData() {
        var sensors = [Sensor]()
        var readings = [Reading]()
        
//        for i in 1...20 {
//            let sensor = Sensor(name: String(format: "S%02d", i), desc: "Sensor number \(i)")
//            sensors.append(sensor)
//        }
//
//        let isSuccessfulSensorsSave = NSKeyedArchiver.archiveRootObject(sensors, toFile: Sensor.ArchiveURL.path)
//        if isSuccessfulSensorsSave {
//            print("Sensors successfully saved.")
//        } else {
//            print("Failed to save meals...")
//        }
//
//        for _ in 1...ViewController.numberOfReadings {
//            let reading = Reading(sensors: sensors)
//            readings.append(reading)
//        }
//
//        let isSuccessfulReadingsSave = NSKeyedArchiver.archiveRootObject(readings, toFile: Reading.ArchiveURL.path)
//        if isSuccessfulReadingsSave {
//            print("Readings successfully saved.")
//        } else {
//            print("Failed to save meals...")
//        }
    }
}

