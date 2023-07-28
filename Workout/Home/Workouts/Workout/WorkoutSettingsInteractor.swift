//
//  
//  WorkoutSettingsInteractor.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//
//
import Foundation
import OSLog

protocol WorkoutSettingsPresenterToInteractorProtocol: AnyObject {
    var workout: Workout { get }
    var workoutName: String { get }
    var exercisesCount: Int { get }
    var timedExercisesCount: Int { get }
    var timedExercisesDuration: String? { get }
    var sessionsCount: Int { get }
    var areSessionsEnabled: Bool { get }
    var areHapticsEnabled: Bool { get }
    func editWorkoutName(with newName: String)
    func emptySessionsIfNeeded()
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutSettingsInteractor: WorkoutSettingsPresenterToInteractorProtocol {
    let workout: Workout
    private let hapticsManager = HapticsManager.shared
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    var workoutName: String { workout.name ?? "" }
    
    var exercisesCount: Int { workout.exercisesCount }
    
    var timedExercisesCount: Int { workout.timedExercisesCount }
    
    var timedExercisesDuration: String? { workout.longFormattedTimedExercisesDurationString }
    
    var sessionsCount: Int { workout.sessionsCount }
    
    var areSessionsEnabled: Bool { exercisesCount > 0 }
    
    var areHapticsEnabled: Bool { hapticsManager.areHapticsEnabled }
    
    func editWorkoutName(with newName: String) {
        Logger.coreData.info("Editing workout \(self.workout) in current managed object context")
        workout.update(with: newName)
    }
    
    func emptySessionsIfNeeded() {
        if exercisesCount == 0 && sessionsCount > 0 {
            workout.emptySessions()
        }
    }
}
