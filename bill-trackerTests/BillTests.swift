//
//  BillTests.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 02/10/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

import XCTest
import Quick
import Nimble
import CoreData
@testable import bill_tracker

class BillTests: QuickSpec {
    override func spec() {

        let stubContext: NSManagedObjectContext = memoryManagedObjectContext()
        let calendar: Calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        var bill: Bill!

        describe("next due date") {

            beforeEach {
                bill = NSEntityDescription.insertNewObject(forEntityName: "Bill", into: stubContext) as! Bill
            }

            describe("never repeating bills") {

                it("equals the due date") {
                    bill.dueDate = Date()
                    bill.repeatInterval = NSNumber(value: RepeatInterval.getByName("never"))

                    expect(bill.nextDueDate).to(equal(bill.dueDate))
                }
            }

            describe("monthly repeating bills") {

                context("due today") {
                    it("equals the due date") {
                        bill.dueDate = Date()
                        bill.repeatInterval = NSNumber(value: RepeatInterval.getByName("monthly"))

                        let dueDateComponents = calendar.dateComponents([.day, .month, .year], from: bill.nextDueDate)

                        expect(dueDateComponents.month).to(equal(currentDateComponents.month))
                    }
                }

                context("due yesterday") {
                    it("is one month after the due date") {
                        var modifyComponent = DateComponents()
                        modifyComponent.day = -1
                        bill.dueDate = calendar.date(byAdding: modifyComponent, to: Date())
                        bill.repeatInterval = NSNumber(value: RepeatInterval.getByName("monthly"))

                        let dueDateComponents = calendar.dateComponents([.day, .month, .year], from: bill.nextDueDate)

                        expect(dueDateComponents.month).to(equal(currentDateComponents.month! + 1))
                    }
                }

                context("due tomorrow") {
                    it("equals the due date") {
                        var modifyComponent = DateComponents()
                        modifyComponent.day = 1
                        bill.dueDate = calendar.date(byAdding: modifyComponent, to: Date())
                        bill.repeatInterval = NSNumber(value: RepeatInterval.getByName("monthly"))

                        let dueDateComponents = calendar.dateComponents([.day, .month, .year], from: bill.nextDueDate)

                        expect(dueDateComponents.month).to(equal(currentDateComponents.month))
                    }
                }
            }
        }
    }
}
