//
//  ReadingCD+CoreDataProperties.swift
//  Lab2
//
//  Created by Karol Perec on 15/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//
//

import Foundation
import CoreData


extension ReadingCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReadingCD> {
        return NSFetchRequest<ReadingCD>(entityName: "ReadingCD")
    }

    @NSManaged public var timestamp: Int32
    @NSManaged public var value: Float
    @NSManaged public var sensor: SensorCD?

}
