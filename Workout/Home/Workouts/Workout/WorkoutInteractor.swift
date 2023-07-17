//
//  
//  WorkoutInteractor.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//
//
import Foundation

protocol WorkoutPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var workout: Workout { get set }
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
final class WorkoutInteractor: WorkoutPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    var workout: Workout
    private let hapticsManager = HapticsManager.shared
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    var workoutName: String {
        workout.name ?? ""
    }
    
    var exercisesCount: Int {
        workout.exercisesCount
    }
    
    var timedExercisesCount: Int {
        workout.timedExercisesCount
    }
    
    var timedExercisesDuration: String? { workout.longFormattedTimedExercisesDurationString }
    
    var sessionsCount: Int { workout.sessionsCount }
    
    var areSessionsEnabled: Bool { exercisesCount > 0 }
    
    var areHapticsEnabled: Bool { hapticsManager.areHapticsEnabled }
    
    func editWorkoutName(with newName: String) {
        workout.update(with: newName)
    }
    
    func emptySessionsIfNeeded() {
        if exercisesCount == 0 && sessionsCount > 0 {
            workout.emptySessions()
        }
    }
}
