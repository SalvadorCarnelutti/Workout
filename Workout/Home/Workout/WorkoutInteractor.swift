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
    
    func editWorkoutName(with newName: String) {
        workout.name = newName
    }
}
