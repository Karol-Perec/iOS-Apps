//
//  SensorCD+CoreDataProperties.swift
//  Lab2
//
//  Created by Karol Perec on 15/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//
//

import Foundation
import CoreData


extension SensorCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SensorCD> {
        return NSFetchRequest<SensorCD>(entityName: "SensorCD")
    }

    @NSManaged public var desc: String?
    @NSManaged public var name: String?
    @NSManaged public var readings: NSSet?

}

// MARK: Generated accessors for readings
extension SensorCD {

    @objc(addReadingsObject:)
    @NSManaged public func addToReadings(_ value: ReadingCD)

    @objc(removeReadingsObject:)
    @NSManaged public func removeFromReadings(_ value: ReadingCD)

    @objc(addReadings:)
    @NSManaged public func addToReadings(_ values: NSSet)

    @objc(removeReadings:)
    @NSManaged public func removeFromReadings(_ values: NSSet)

}
