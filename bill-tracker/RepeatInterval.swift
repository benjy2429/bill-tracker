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
    static func getByID(_ id: Int) -> String {
        return intervals[id].capitalized
    }

    static func getByName(_ name: String) -> Int {
        return intervals.index(of: name)!
    }

    static func humanized() -> [String] {
        return intervals.map {
            $0.capitalized
        }
    }
}
