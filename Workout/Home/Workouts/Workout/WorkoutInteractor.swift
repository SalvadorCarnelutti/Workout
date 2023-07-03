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
    var timedExercisesDurationString: String { get }
    var sessionsCount: Int { get }
    func editWorkoutName(with newName: String)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutInteractor: WorkoutPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    var workout: Workout
    
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
    
    var timedExercisesDurationString: String {
        workout.timedExercisesDurationString
    }
    
    var sessionsCount: Int {
        workout.sessionsCount
    }
    
    func editWorkoutName(with newName: String) {
        workout.update(with: newName)
    }
}
