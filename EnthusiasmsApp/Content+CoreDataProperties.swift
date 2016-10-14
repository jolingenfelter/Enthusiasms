//
//  Content+CoreDataProperties.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/14/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreData
import 

extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content");
    }

    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var video: String?
    @NSManaged public var studentContent: Student?

}
