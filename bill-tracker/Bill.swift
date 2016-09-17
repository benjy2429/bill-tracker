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
    @NSManaged var dueDate: NSDate?
    @NSManaged var category: Category?

    var amountHumanized: String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        return formatter.stringFromNumber(amount!)!
    }

    var dueDateHumanized: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE dd MMM"
        print(dueDate)
        return formatter.stringFromDate(dueDate!)
    }

    class func create(context: NSManagedObjectContext, params: (name: String, amount: NSDecimalNumber, dueDate: NSDate, category: Category)) -> Bill {
        let newBill = NSEntityDescription.insertNewObjectForEntityForName("Bill", inManagedObjectContext: context) as! Bill
        newBill.name = params.name
        newBill.amount = params.amount
        newBill.dueDate = params.dueDate
        newBill.category = params.category

        return newBill
    }

    func validate() {
        // TODO: Migrate from viewcontrollers
    }
}
