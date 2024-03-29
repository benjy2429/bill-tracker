//
//  Category.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 08/09/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Category: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var icon: String?
    @NSManaged var colourRed: NSNumber?
    @NSManaged var colourGreen: NSNumber?
    @NSManaged var colourBlue: NSNumber?
    @NSManaged var bills: NSSet?

    var colour: UIColor {
        return UIColor(
            red: CGFloat(colourRed!),
            green: CGFloat(colourGreen!),
            blue: CGFloat(colourBlue!),
            alpha: 1.0)
    }

    class func create(_ context: NSManagedObjectContext, params: (name: String, icon: String, colour: (red: Double, green: Double, blue: Double))) -> Category {
        let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        newCategory.name = params.name
        newCategory.icon = params.icon
        newCategory.colourRed = NSNumber(value: params.colour.red)
        newCategory.colourGreen = NSNumber(value: params.colour.green)
        newCategory.colourBlue = NSNumber(value: params.colour.blue)

        return newCategory
    }
}
