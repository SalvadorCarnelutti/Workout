////
////  
//  ScheduledSessionFormRouter.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
////
import UIKit

protocol ScheduledSessionFormPresenterToRouterProtocol: AnyObject {
    var presenter: ScheduledSessionFormRouterToPresenterProtocol! { get set }
    func presentEditExerciseForm(for exercise: Exercise)
    func popViewController()
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionFormRouter: BaseRouter, ScheduledSessionFormPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: ScheduledSessionFormRouterToPresenterProtocol!
    
    func presentEditExerciseForm(for exercise: Exercise) {        
        let editExerciseFormViewController = ExerciseFormConfigurator.resolveEdit(for: exercise) { [weak presenter] formOutput in
            presenter?.editCompletionAction(for: exercise, formOutput: formOutput)
        }
        
        editExerciseFormViewController.modalPresentationStyle = .popover
        navigationController?.present(editExerciseFormViewController, animated: true)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
