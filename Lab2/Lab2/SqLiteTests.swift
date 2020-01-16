//
//  SqLiteTests.swift
//  Lab2
//
//  Created by Karol Perec on 14/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//

import Foundation
import SQLite3

func generateDataSqLite() {
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("Lab2.db")?.path
    do {
        try FileManager.default.removeItem(atPath: dbFilePath!)
    } catch {
        print("Could not delete file: \(error)")
    }
    
    var db: OpaquePointer? = nil
    
    if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
        print("ok")
    } else {
        print("fail")
    }
    
    var querySQL = "CREATE TABLE sensors (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(50), desc VARCHAR(50));"
    sqlite3_exec(db, querySQL, nil, nil, nil)
    
    querySQL = "CREATE TABLE readings (id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp INTEGER, value REAL, sensor INTEGER NOT NULL, FOREIGN KEY (sensor) REFERENCES sensors (id) );"
    sqlite3_exec(db, querySQL, nil, nil, nil)

    querySQL = "INSERT INTO sensors (name, desc) VALUES "
    for i in 1...20 {
        querySQL += "('\(String(format: "S%02d", i))', 'Sensor number \(i)'),"
    }
    querySQL.removeLast()
    querySQL += ";"
    sqlite3_exec(db, querySQL, nil, nil, nil)

    querySQL = "INSERT INTO readings (timestamp, value, sensor) VALUES "
    for _ in 1...ViewController.numberOfReadings {
        querySQL += "(\(Int.random(in: 1546300800 ... 1577836799)), \(Float.random(in: 0 ... 100)), \(Int.random(in: 1 ... 20))),"
    }
    querySQL.removeLast()
    querySQL += ";"
    sqlite3_exec(db, querySQL, nil, nil, nil)
    
    sqlite3_close(db)
}

func timestampQuerySqLite() {
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("Lab2.db")?.path
    
    var db: OpaquePointer? = nil
    
    if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
        print("ok")
    } else {
        print("fail")
    }
    
    var querySQL = "SELECT MIN(timestamp) FROM readings;"
    sqlite3_exec(db, querySQL,
            {_, columnCount, values, columns in
                for i in 0 ..< Int(columnCount) {
                    let column = String(cString: columns![i]!)
                    let value = String(cString: values![i]!)
                    print("  \(column) = \(value)")
                }
                return 0
            }, nil, nil)
    
    querySQL = "SELECT MAX(timestamp) FROM readings;"
    sqlite3_exec(db, querySQL,
                 {_, columnCount, values, columns in
                    for i in 0 ..< Int(columnCount) {
                        let column = String(cString: columns![i]!)
                        let value = String(cString: values![i]!)
                        print("  \(column) = \(value)")
                    }
                    return 0
    }, nil, nil)
    
    sqlite3_close(db)
}

func averageReadingQuerySqLite() {
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("Lab2.db")?.path
    
    var db: OpaquePointer? = nil
    
    if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
        print("ok")
    } else {
        print("fail")
    }
    
    var querySQL = "SELECT AVG(value) FROM readings;"
    sqlite3_exec(db, querySQL,
                 {_, columnCount, values, columns in
                    let avg = String(cString: values![0]!)
                    print("Average reading: \(avg)")
                    return 0
    }, nil, nil)
    
    sqlite3_close(db)
}

func readingPerSensorQuerySqLite() {
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("Lab2.db")?.path
    
    var db: OpaquePointer? = nil
    
    if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
        print("ok")
    } else {
        print("fail")
    }
    
    for i in 1...20 {
        let querySQL = "SELECT sensor, AVG(value), COUNT() FROM readings WHERE sensor=\(i);"
        sqlite3_exec(db, querySQL,
                     {_, columnCount, values, columns in
                        if values![0] != nil {
                            let sensor = String(cString: values![0]!)
                            let avg = String(cString: values![1]!)
                            let nmb = String(cString: values![2]!)
                            print("Average reading for sensor \(sensor): \(avg), number of readings: \(nmb)")
                        }
                        return 0
        }, nil, nil)
    }
    
    sqlite3_close(db)
}
