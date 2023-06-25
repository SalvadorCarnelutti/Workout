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
        guard let workout = presenter?.workout else { return }
        
        switch section {
        case .edit:
            presentEditWorkoutName()
        case .exercises:
            pushExercises(for: workout)
        case .sessions:
            pushSessions(for: workout)
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
        
        let exercisesViewController = ExercisesConfigurator.resolveEdit(for: workout)
        presenter.navigationController?.pushViewController(exercisesViewController, animated: true)
    }
    
    private func pushSessions(for workout: Workout) {
        guard let presenter = presenter else { return }

        let sessionsViewController = SessionsConfigurator.resolve(for: workout)
        presenter.navigationController?.pushViewController(sessionsViewController, animated: true)
    }
}
