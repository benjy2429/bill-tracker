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

    class func create(context: NSManagedObjectContext, params: (name: String, icon: String, colour: (red: Float, green: Float, blue: Float))) -> Category {
        let newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as! Category
        newCategory.name = params.name
        newCategory.icon = params.icon
        newCategory.colourRed = params.colour.red
        newCategory.colourGreen = params.colour.green
        newCategory.colourBlue = params.colour.blue

        return newCategory
    }
}
