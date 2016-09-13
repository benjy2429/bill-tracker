//
//  seed.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 13/09/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

import Foundation
import CoreData

class Seed {

    class func seedCategories(context: NSManagedObjectContext) {

        let categories = [
            (name: "Test Category", icon: "?", colour: (red: Float(1.0), green: Float(1.0), blue: Float(0.0)))
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