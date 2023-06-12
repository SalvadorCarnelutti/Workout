////
////  
//  WorkoutRouter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
////
import UIKit
import CoreData

protocol WorkoutPresenterToRouterProtocol: AnyObject {
    var presenter: WorkoutRouterToPresenterProtocol? { get set }
    func presentEditWorkout()
    func presentAddExerciseForm()
    func presentEditExerciseForm(for exercise: Exercise)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutRouter: WorkoutPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: WorkoutRouterToPresenterProtocol?
    
    func presentEditWorkout() {
        guard let presenter = presenter else { return }
        
        let editWorkoutFormViewController = WorkoutFormConfigurator.resolveEdit(for: presenter.workoutName, completionAction: presenter.editWorkoutName)
        editWorkoutFormViewController.modalPresentationStyle = .popover
        presenter.present(editWorkoutFormViewController, animated: true)
    }
    
    func presentAddExerciseForm() {
        guard let presenter = presenter else { return }
        
        let addExerciseFormViewController = ExerciseFormConfigurator.resolveAdd(completionAction: presenter.addCompletionAction)
        addExerciseFormViewController.modalPresentationStyle = .popover
        presenter.present(addExerciseFormViewController, animated: true)
    }
    
    func presentEditExerciseForm(for exercise: Exercise) {
        guard let presenter = presenter else { return }
        
        let editExerciseFormViewController = ExerciseFormConfigurator.resolveEdit(for: exercise) { [weak self] formOutput in
            self?.presenter?.editCompletionAction(for: exercise, formOutput: formOutput)
        }
        
        editExerciseFormViewController.modalPresentationStyle = .popover
        presenter.present(editExerciseFormViewController, animated: true)
    }
}
