//
//  Workout.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import CoreData
import OSLog

extension Workout {
    private var compactMappedExercises: [Exercise] { exercises?.compactMap { $0 as? Exercise } ?? [] }
    var compactMappedSessions: [Session] { sessions?.compactMap { $0 as? Session } ?? [] }
    
    var exercisesCount: Int {
        compactMappedExercises.count
    }
    
    var sessionsCount: Int {
        compactMappedSessions.count
    }
        
    var timedExercisesCount: Int {
        compactMappedExercises.filter { $0.minutesDuration > 0 }.count
    }
    
    var timedExercisesDuration: Int {
        compactMappedExercises.reduce (0, { $0 + Int($1.minutesDuration) })
    }
    
    var longFormattedTimedExercisesDurationString: String? {
        Double(timedExercisesDuration).asLongFormattedDurationString
    }
    
    var shortFormattedTimedExercisesDurationString: String? {
        Double(timedExercisesDuration).asShortFormattedDurationString
    }
    
    func setup(with name: String) {
        uuid = UUID()
        self.name = name
        Logger.coreData.info("New workout \(self) added to managed object context")
    }
    
    func update(with newName: String) {
        self.name = newName
        Logger.coreData.info("Workout updated to \(self) in current managed object context")
    }
    
    func emptySessions() { compactMappedSessions.forEach { $0.delete() } }
}
