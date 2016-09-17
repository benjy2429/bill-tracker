//
//  seed.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 13/09/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

import Foundation
import CoreData
import FontAwesome_swift

class Seed {

    class func seedCategories(context: NSManagedObjectContext) {

        let categories = [
            (name: "Rent", icon: String.fontAwesomeIconWithName(.Home), colour: (red: Float(0.4), green: Float(1.0), blue: Float(1.0))),
            (name: "Car", icon: String.fontAwesomeIconWithName(.Car), colour: (red: Float(1.0), green: Float(0.4), blue: Float(0.4))),
            (name: "Phone", icon: String.fontAwesomeIconWithName(.Phone), colour: (red: Float(1.0), green: Float(0.7), blue: Float(0.4))),
            (name: "Card", icon: String.fontAwesomeIconWithName(.CreditCardAlt), colour: (red: Float(0.5), green: Float(0.4), blue: Float(1.0))),
            (name: "Money", icon: String.fontAwesomeIconWithName(.Money), colour: (red: Float(0.4), green: Float(1.0), blue: Float(0.6))),
            (name: "Water", icon: String.fontAwesomeIconWithName(.Tint), colour: (red: Float(0.4), green: Float(0.8), blue: Float(1.0))),
            (name: "Electricity", icon: String.fontAwesomeIconWithName(.Bolt), colour: (red: Float(1.0), green: Float(1.0), blue: Float(0.4))),
            (name: "TV", icon: String.fontAwesomeIconWithName(.Television), colour: (red: Float(1.0), green: Float(0.4), blue: Float(0.7)))
        ]

        for category in categories {
            Category.create(context, params: category)
        }

        do {
            try context.save()
        } catch {
            fatalError("Error saving bill: \(error)")
        }
    }
}