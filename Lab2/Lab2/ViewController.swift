//
//  ViewController.swift
//  Lab2
//
//  Created by Karol Perec on 12/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController {
    static let numberOfReadings = 10
    
    @IBOutlet weak var dataGenerationInfo: UILabel!
    @IBOutlet weak var timestampQueryInfo: UILabel!
    @IBOutlet weak var averageReadingInfo: UILabel!
    @IBOutlet weak var readingPerSensorInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func runArchivingTest(_ sender: UIButton) {
        
        let t1 = NSDate()
        generateDataArchiving()
        let t2 = NSDate()
        dataGenerationInfo.text = "\(t2.timeIntervalSince(t1 as Date))"
    
        timestampQueryArchiving()
        let t3 = NSDate()
        timestampQueryInfo.text = "\(t3.timeIntervalSince(t2 as Date))"
        
        averageReadingQueryArchiving()
        let t4 = NSDate()
        averageReadingInfo.text = "\(t4.timeIntervalSince(t3 as Date))"
        
        readingPerSensorQueryArchiving()
        let t5 = NSDate()
        readingPerSensorInfo.text = "\(t5.timeIntervalSince(t4 as Date))"
    }
    
    @IBAction func runSqLiteTests(_ sender: UIButton) {
        let t1 = NSDate()
        generateDataSqLite()
        let t2 = NSDate()
        dataGenerationInfo.text = "\(t2.timeIntervalSince(t1 as Date))"
        
        timestampQuerySqLite()
        let t3 = NSDate()
        timestampQueryInfo.text = "\(t3.timeIntervalSince(t2 as Date))"
        
        averageReadingQuerySqLite()
        let t4 = NSDate()
        averageReadingInfo.text = "\(t4.timeIntervalSince(t3 as Date))"
        
        readingPerSensorQuerySqLite()
        let t5 = NSDate()
        readingPerSensorInfo.text = "\(t5.timeIntervalSince(t4 as Date))"
    }
    
    @IBAction func runCoreDataTests(_ sender: UIButton) {
        let t1 = NSDate()
        generateDataCoreData()
        let t2 = NSDate()
        dataGenerationInfo.text = "\(t2.timeIntervalSince(t1 as Date))"
        
        timestampQueryCoreData()
        let t3 = NSDate()
        timestampQueryInfo.text = "\(t3.timeIntervalSince(t2 as Date))"
        
        averageReadingQueryCoreData()
        let t4 = NSDate()
        averageReadingInfo.text = "\(t4.timeIntervalSince(t3 as Date))"
        
        readingPerSensorQueryCoreData()
        let t5 = NSDate()
        readingPerSensorInfo.text = "\(t5.timeIntervalSince(t4 as Date))"
    }
    
}
