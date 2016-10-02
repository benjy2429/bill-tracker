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

    class func seedCategories(_ context: NSManagedObjectContext) {

        let categories = [
            (name: "Rent", icon: String.fontAwesomeIconWithName(.Home), colour: (red: 0.4, green: 1.0, blue: 1.0)),
            (name: "Car", icon: String.fontAwesomeIconWithName(.Car), colour: (red: 1.0, green: 0.4, blue: 0.4)),
            (name: "Phone", icon: String.fontAwesomeIconWithName(.Phone), colour: (red: 1.0, green: 0.7, blue: 0.4)),
            (name: "Card", icon: String.fontAwesomeIconWithName(.CreditCardAlt), colour: (red: 0.5, green: 0.4, blue: 1.0)),
            (name: "Money", icon: String.fontAwesomeIconWithName(.Money), colour: (red: 0.4, green: 1.0, blue: 0.6)),
            (name: "Water", icon: String.fontAwesomeIconWithName(.Tint), colour: (red: 0.4, green: 0.8, blue: 1.0)),
            (name: "Electricity", icon: String.fontAwesomeIconWithName(.Bolt), colour: (red: 1.0, green: 1.0, blue: 0.4)),
            (name: "TV", icon: String.fontAwesomeIconWithName(.Television), colour: (red: 1.0, green: 0.4, blue: 0.7))
        ]

        for category in categories {
            _ = Category.create(context, params: category)
        }

        do {
            try context.save()
        } catch {
            fatalError("Error saving bill: \(error)")
        }
    }
}
