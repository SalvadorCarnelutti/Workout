//
//  Workout.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import CoreData

extension Workout {
    var exercisesCount: Int {
        exercises?.count ?? 0
    }
    
    var timedExercisesCount: Int {
        exercises?.compactMap({ $0 as? Exercise }).filter { $0.minutesDuration > 0 }.count ?? 0
    }
    
    var timedExercisesDuration: Int {
        exercises?.compactMap({ $0 as? Exercise }).reduce (0, { $0 + Int($1.minutesDuration) }) ?? 0
    }
    
    var longFormattedTimedExercisesDurationString: String? {
        Double(timedExercisesDuration).asLongFormattedDurationString
    }
    
    var shortFormattedTimedExercisesDurationString: String? {
        Double(timedExercisesDuration).asShortFormattedDurationString
    }
    
    var sessionsCount: Int {
        sessions?.count ?? 0
    }
    
    func setup(with name: String) {
        uuid = UUID()
        self.name = name
    }
    
    func update(with name: String) {
        self.name = name
    }
}
