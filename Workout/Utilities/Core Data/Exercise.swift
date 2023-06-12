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
    
    var setsString: String {
        String(sets)
    }
    
    var repsString: String {
        String(reps)
    }
    
    var itemOrder: Int {
        Int(order) + 1
    }
    
    func configure(with formOutput: FormOutput) {
        name = formOutput.name
        duration = Double(formOutput.duration)
        sets = Int16(formOutput.sets)
        reps = Int16(formOutput.reps)
    }
}
