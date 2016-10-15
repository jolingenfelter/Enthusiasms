//
//  Student+CoreDataProperties.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/14/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student");
    }

    @NSManaged public var name: String?
    @NSManaged public var rewardTime: Double
    @NSManaged public var contents: NSSet?

}

// MARK: Generated accessors for contents
extension Student {

    @objc(addContentsObject:)
    @NSManaged public func addToContents(_ value: Content)

    @objc(removeContentsObject:)
    @NSManaged public func removeFromContents(_ value: Content)

    @objc(addContents:)
    @NSManaged public func addToContents(_ values: NSSet)

    @objc(removeContents:)
    @NSManaged public func removeFromContents(_ values: NSSet)

}
