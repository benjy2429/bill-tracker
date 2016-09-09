//
//  Category.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 08/09/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

import Foundation
import CoreData


class Category: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var attribute: String?
    @NSManaged var bills: NSSet?
}
