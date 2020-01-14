//
//  Sensor.swift
//  Lab2
//
//  Created by Karol Perec on 14/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//

import Foundation

class Sensor: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var desc: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("sensors")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let desc = "desc"
    }
    
    //MARK: Initialization
    init(name: String, desc: String) {
        self.name = name
        self.desc = desc
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(desc, forKey: PropertyKey.desc)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as! String
        let desc = aDecoder.decodeObject(forKey: PropertyKey.desc) as! String
        
        self.init(name: name, desc: desc)
    }
}
