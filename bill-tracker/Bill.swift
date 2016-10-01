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
    @NSManaged var payee: String?
    @NSManaged var dueDate: NSDate?
    @NSManaged var repeatInterval: NSNumber?
    @NSManaged var category: Category?

    var amountHumanized: String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        return formatter.stringFromNumber(amount!)!
    }

    var dueDateHumanized: String {
        return humanizeDate(dueDate!)
    }

    var nextDueDate: NSDate {
        let calendar = NSCalendar.currentCalendar()
        let dueComponents = calendar.components([.Day, .Month, .Year], fromDate: dueDate!)
        let currentComponents = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        let newComponents = NSDateComponents()

        switch repeatInterval as! Int {
//        case 1:
//            // Daily
//        case 2:
//            // Weekly
        case 3:
            // Monthly
            newComponents.day = dueComponents.day
            newComponents.month = currentComponents.month
            newComponents.year = currentComponents.year
            let newDate = calendar.dateFromComponents(newComponents)

            let daysToAdd = (currentComponents.day > dueComponents.day) ? 2 : 1
            return calendar.dateByAddingUnit(.Month, value: daysToAdd, toDate: newDate!, options: [])!

//        case 4:
//            // Yearly
        default:
            return dueDate!
        }
    }

    var nextDueDateHumanized: String {
        return humanizeDate(nextDueDate)
    }

    class func create(context: NSManagedObjectContext, params: (name: String, amount: NSDecimalNumber, payee: String, dueDate: NSDate, category: Category, repeatInterval: Int)) -> Bill {
        let newBill = NSEntityDescription.insertNewObjectForEntityForName("Bill", inManagedObjectContext: context) as! Bill
        newBill.name = params.name
        newBill.amount = params.amount
        newBill.payee = params.payee
        newBill.dueDate = params.dueDate
        newBill.category = params.category
        newBill.repeatInterval = params.repeatInterval

        return newBill
    }

    func update(params: (name: String, amount: NSDecimalNumber, payee: String, dueDate: NSDate, category: Category, repeatInterval: Int)) {
        name = params.name
        amount = params.amount
        payee = params.payee
        dueDate = params.dueDate
        category = params.category
        repeatInterval = params.repeatInterval
    }

    func humanizeDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE dd MMM"
        return formatter.stringFromDate(date)
    }

    func validate() {
        // TODO: Migrate from viewcontrollers
    }


}
