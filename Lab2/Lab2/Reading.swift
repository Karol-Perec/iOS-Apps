//
//  Reading.swift
//  Lab2
//
//  Created by Karol Perec on 14/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//

import Foundation

class Reading: NSObject, NSCoding {
    
    //MARK: Properties
    var timestamp: Double
    var sensor: Sensor
    var value: Float
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("readings")
    
    //MARK: Types
    struct PropertyKey {
        static let timestamp = "timestamp"
        static let sensor = "sensor"
        static let value = "value"
    }
    
    //MARK: Initialization
    init(sensors: [Sensor]) {
        self.timestamp = Double.random(in: 1546300800 ... 1577836799)
        self.sensor = sensors.randomElement()!
        self.value = Float.random(in: 0 ... 100)
    }
    
    init(timestamp: Double, sensor: Sensor, value: Float) {
        self.timestamp = timestamp
        self.sensor = sensor
        self.value = value
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(timestamp, forKey: PropertyKey.timestamp)
        aCoder.encode(sensor, forKey: PropertyKey.sensor)
        aCoder.encode(value, forKey: PropertyKey.value)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let timestamp = aDecoder.decodeDouble(forKey: PropertyKey.timestamp)
        let sensor = aDecoder.decodeObject(forKey: PropertyKey.sensor) as! Sensor
        let value = aDecoder.decodeFloat(forKey: PropertyKey.value)
        
        self.init(timestamp: timestamp, sensor: sensor, value: value)
    }
}
