////
////  
//  WorkoutRouter.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//
////
import UIKit

protocol WorkoutPresenterToRouterProtocol: AnyObject {
    var presenter: WorkoutRouterToPresenterProtocol? { get set }
    func handleSectionRouting(for section: WorkoutSection)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutRouter: WorkoutPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: WorkoutRouterToPresenterProtocol?
    
    func handleSectionRouting(for section: WorkoutSection) {
        guard let presenter = presenter else { return }
        
        switch section {
        case .edit:
            presentEditWorkoutName()
        case .exercises:
            pushExercises(for: presenter.workout)
        case .sessions:
            pushSessions()
        }
    }
    
    func presentEditWorkoutName() {
        guard let presenter = presenter else { return }
        
        let editWorkoutFormViewController = WorkoutFormConfigurator.resolveEdit(for: presenter.workoutName, completionAction: presenter.editWorkoutName)
        editWorkoutFormViewController.modalPresentationStyle = .popover
        presenter.present(editWorkoutFormViewController, animated: true)
    }
    
    private func pushExercises(for workout: Workout) {
        guard let presenter = presenter else { return }
        
        let editWorkoutViewController = ExercisesConfigurator.resolveEdit(for: workout)
        presenter.navigationController?.pushViewController(editWorkoutViewController, animated: true)
    }
    
    private func pushSessions() {
        guard let presenter = presenter else { return }

        
    }
}
