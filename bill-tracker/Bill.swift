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
    @NSManaged var dueDate: Date?
    @NSManaged var repeatInterval: NSNumber?
    @NSManaged var category: Category?

    var amountHumanized: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: amount!)!
    }

    var dueDateHumanized: String {
        return humanizeDate(dueDate!)
    }

    var nextDueDate: Date {
        let calendar = Calendar.current
        let dueComponents = calendar.dateComponents([.day, .month, .year], from: dueDate!)
        let currentComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        var newComponents = DateComponents()

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
            let newDate = calendar.date(from: newComponents)!

            if (currentComponents.day! > dueComponents.day!) {
                return calendar.date(byAdding: .month, value: 1, to: newDate)!
            }

            return newDate

//        case 4:
//            // Yearly
        default:
            return dueDate!
        }
    }

    var nextDueDateHumanized: String {
        return humanizeDate(nextDueDate)
    }

    class func create(_ context: NSManagedObjectContext, params: (name: String, amount: NSDecimalNumber, payee: String, dueDate: Date, category: Category, repeatInterval: Int)) -> Bill {
        let newBill = NSEntityDescription.insertNewObject(forEntityName: "Bill", into: context) as! Bill
        newBill.name = params.name
        newBill.amount = params.amount
        newBill.payee = params.payee
        newBill.dueDate = params.dueDate
        newBill.category = params.category
        newBill.repeatInterval = params.repeatInterval as NSNumber?

        return newBill
    }

    func update(_ params: (name: String, amount: NSDecimalNumber, payee: String, dueDate: Date, category: Category, repeatInterval: Int)) {
        name = params.name
        amount = params.amount
        payee = params.payee
        dueDate = params.dueDate
        category = params.category
        repeatInterval = params.repeatInterval as NSNumber?
    }

    func humanizeDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd MMM"
        return formatter.string(from: date)
    }

    class func billsDueThisMonth(_ bills: [Bill]) -> [Bill] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())

        return bills.filter() {
            let month = calendar.component(.month, from: $0.nextDueDate)
            return month == currentMonth
        }
    }

    func validate() {
        // TODO: Migrate from viewcontrollers
    }


}
