//
//  CoreDataTests.swift
//  Lab2
//
//  Created by Karol Perec on 15/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//

import Foundation
import CoreData
import UIKit

func generateDataCoreData() {
    deleteAllData("SensorCD")
    deleteAllData("ReadingCD")
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    for i in 1...20 {
        let sensor = SensorCD(context: managedContext)
        sensor.name = String(format: "S%02d", i)
        sensor.desc = "Sensor number \(i)"
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    for _ in 1...ViewController.numberOfReadings {
        let reading = ReadingCD(context: managedContext)
        reading.timestamp = Int32.random(in: 1546300800 ... 1577836799)
        reading.value = Float.random(in: 0 ... 100)
        if let sensor = fetchRandomSensor(managedContext: managedContext) {
//            reading.sensor = sensor
            sensor.addToReadings(reading)
        } else {
            print("Error occured while fetching sensor")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

func timestampQueryCoreData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let request:NSFetchRequest<ReadingCD> = ReadingCD.fetchRequest()
    request.fetchLimit = 1
    
    var predicate = NSPredicate(format: "timestamp == max(timestamp)")
    request.predicate = predicate
    
    do {
        let result = try managedContext.fetch(request).first
        print("Max timetamp: \(result!.timestamp)")
    } catch {
        print("Unresolved error in retrieving max timestamp: \(error)")
    }
    
    predicate = NSPredicate(format: "timestamp == min(timestamp)")
    request.predicate = predicate
    
    do {
        let result = try managedContext.fetch(request).first
        print("Min timetamp: \(result!.timestamp)")
    } catch {
        print("Unresolved error in retrieving min timestamp: \(error)")
    }
}

func averageReadingQueryCoreData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSDictionary>(entityName:"ReadingCD")
    request.resultType = .dictionaryResultType
    let ed = NSExpressionDescription()
    ed.name = "AverageValue"
    ed.expression = NSExpression(format: "@avg.value")
    ed.expressionResultType = .floatAttributeType
    request.propertiesToFetch = [ed]
    
    do {
        let result = try managedContext.fetch(request)
        print("Average reading: \(result.first!)")
    } catch {
        print("Unresolved error in retrieving average reading value: \(error)")
    }
}

func readingPerSensorQueryCoreData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSDictionary>(entityName:"ReadingCD")
    request.resultType = .dictionaryResultType
    let ed = NSExpressionDescription()
    ed.name = "AverageValue"
    ed.expression = NSExpression(format: "@avg.value")
    ed.expressionResultType = .floatAttributeType
    
    let ed2 = NSExpressionDescription()
    ed2.name = "CountReadings"
    let keypathExp = NSExpression(forKeyPath: "value") // can be any column
    ed2.expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
    ed2.expressionResultType = .integer64AttributeType
    request.propertiesToFetch = [ed, ed2]
    
    for i in 1 ... 20 {
        var predicate = NSPredicate(format: "sensor.name == %@", String(format: "S%02d", i))
        request.predicate = predicate
    
        do {
            let result = try managedContext.fetch(request)
            if (result[0]["AverageValue"] != nil) {
                print("Sensor number \(i), number of readings: \(result[0]["CountReadings"]!), average reading: \(result[0]["AverageValue"]!)")
            }
        } catch {
            print("Unresolved error in retrieving average reading value: \(error)")
        }
    }
}

func deleteAllData(_ entity:String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    fetchRequest.returnsObjectsAsFaults = false
    do {
        let results = try managedContext.fetch(fetchRequest)
        for object in results {
            guard let objectData = object as? NSManagedObject else {continue}
            managedContext.delete(objectData)
        }
    } catch let error {
        print("Detele all data in \(entity) error :", error)
    }
}

func fetchRandomSensor(managedContext: NSManagedObjectContext) -> SensorCD? {
    let fetchRequest:NSFetchRequest<SensorCD> = SensorCD.fetchRequest()
    let predicate = NSPredicate(format: "name == %@", String(format: "S%02d", Int.random(in: 1 ... 20)))
    fetchRequest.predicate = predicate
    do {
        let fetchResults = try managedContext.fetch(fetchRequest)
        return fetchResults.first
    }
    catch let error {
        print("Error: \(error)")
    }
    
    return nil
}
