//
//  Workout.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import CoreData

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
    }
    
    func update(with name: String) {
        self.name = name
    }
    
    func emptySessions() { compactMappedSessions.forEach { $0.delete() } }
}
