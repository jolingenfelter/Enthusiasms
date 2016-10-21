//
//  Content+CoreDataProperties.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/15/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreData

extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content");
    }

    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var video: String?
    @NSManaged public var studentContent: NSSet?

}

// MARK: Generated accessors for studentContent
extension Content {

    @objc(addStudentContentObject:)
    @NSManaged public func addToStudentContent(_ value: Student)

    @objc(removeStudentContentObject:)
    @NSManaged public func removeFromStudentContent(_ value: Student)

    @objc(addStudentContent:)
    @NSManaged public func addToStudentContent(_ values: NSSet)

    @objc(removeStudentContent:)
    @NSManaged public func removeFromStudentContent(_ values: NSSet)

}
