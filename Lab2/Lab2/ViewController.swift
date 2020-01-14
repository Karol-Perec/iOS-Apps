//
//  ViewController.swift
//  Lab2
//
//  Created by Karol Perec on 12/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//

import UIKit

//class Reading: NSObject, NSCoding {
//    var timestamp: Int
//    var sensor: String
//    var value: Float
//
//    init?(timestamp: Int, sensor: String, value: Float) {
//        self.timestamp = timestamp
//        self.sensor = sensor
//        self.value = value
//    }
//}

class ViewController: UIViewController {
    
    var sensors = [Sensor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func runArchivingTest(_ sender: UIButton) {
        
        let sensor1 = Sensor(name: "S1", desc: "temp")

        sensors += [sensor1]

        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(sensors, toFile: Sensor.ArchiveURL.path)
        if isSuccessfulSave {
            print("Meals successfully saved.")
        } else {
            print("Failed to save meals...")
        }


        guard let data2 = NSKeyedUnarchiver.unarchiveObject(withFile: Sensor.ArchiveURL.path) as? [Sensor] else {
            fatalError("Cannot read data")
        }

        debugPrint("xd")
        for sensor in data2 {
            print(sensor.name + sensor.desc)
        }
        
        let reading1 = Reading(sensors: sensors)
        print(reading1.timestamp + " " + reading1.sensor.name + reading1.sensor.desc + " " + reading1.value)

    }
}

