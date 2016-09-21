//
//  RepeatInterval.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 21/09/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

let intervals:[String] = [
    "never",
    "daily",
    "weekly",
    "monthly",
    "yearly"
]

class RepeatInterval {
    static func getByID(id: Int) -> String {
        return intervals[id].capitalizedString
    }

    static func getByName(name: String) -> Int {
        return intervals.indexOf(name)!
    }

    static func humanized() -> [String] {
        return intervals.map {
            $0.capitalizedString
        }
    }
}