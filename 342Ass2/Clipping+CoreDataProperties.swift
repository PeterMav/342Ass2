//
//  Clipping+CoreDataProperties.swift
//  342Ass2
//
//  Created by Peter Mavridis on 8/05/2016.
//  Copyright © 2016 Peter Mavridis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Clipping {

    @NSManaged var dateCreated: NSDate?
    @NSManaged var notes: String?
    @NSManaged var image: String?
    @NSManaged var owner: Collection?

}
