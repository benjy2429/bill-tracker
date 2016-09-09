//
//  Bill.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 08/09/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

import Foundation
import CoreData


class Bill: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var amount: NSDecimalNumber?
    @NSManaged var date: NSDate?
    @NSManaged var category: Category?

    class func create(context: NSManagedObjectContext, name: String) -> Bill {
        let newBill = NSEntityDescription.insertNewObjectForEntityForName("Bill", inManagedObjectContext: context) as! Bill
        newBill.name = name

        return newBill
    }
}
