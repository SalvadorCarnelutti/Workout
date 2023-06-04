//
//  Exercise.swift
//  Workout
//
//  Created by Salvador on 6/4/23.
//

import CoreData

extension Exercise {
    var durationString: String {
        String(format: "%.0f", duration)
    }
    
    var repsString: String {
        String(reps)
    }
    
    var setsString: String {
        String(sets)
    }
}
