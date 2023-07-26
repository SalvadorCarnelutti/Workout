//
//  Exercise.swift
//  Workout
//
//  Created by Salvador on 6/4/23.
//

import CoreData
import OSLog

extension Exercise {
    var durationString: String? {
        guard minutesDuration > 0 else { return nil }
        
        return String(format: "%.0f", minutesDuration)
    }
    
    var formattedDurationString: String? {
        guard minutesDuration > 0 else { return nil }
        
        return minutesDuration.asLongFormattedDurationString
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
    
    func setup(with formOutput: ExerciseFormOutput, order: Int, for workout: Workout) {
        uuid = UUID()
        name = formOutput.name
        minutesDuration = Double(formOutput.minutesDuration ?? 0)
        sets = Int16(formOutput.sets)
        reps = Int16(formOutput.reps)
        self.order = Int16(order)
        self.workout = workout
        Logger.coreData.info("New exercise \(self) added to managed object context")
    }
    
    func update(with formOutput: ExerciseFormOutput) {
        name = formOutput.name
        minutesDuration = Double(formOutput.minutesDuration ?? 0)
        sets = Int16(formOutput.sets)
        reps = Int16(formOutput.reps)
        Logger.coreData.info("Exercise updated to \(self) in current managed object context")
    }
}
