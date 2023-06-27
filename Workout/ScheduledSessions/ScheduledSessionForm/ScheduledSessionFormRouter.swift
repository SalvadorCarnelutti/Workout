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
    var presenter: ScheduledSessionFormRouterToPresenterProtocol? { get set }
    func presentEditExerciseForm(for exercise: Exercise)
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionFormRouter: ScheduledSessionFormPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: ScheduledSessionFormRouterToPresenterProtocol?
    
    func presentEditExerciseForm(for exercise: Exercise) {
        guard let presenter = presenter else { return }
        
        let editExerciseFormViewController = ExerciseFormConfigurator.resolveEdit(for: exercise) { [weak self] formOutput in
            self?.presenter?.editCompletionAction(for: exercise, formOutput: formOutput)
        }
        
        editExerciseFormViewController.modalPresentationStyle = .popover
        presenter.present(editExerciseFormViewController, animated: true)
    }
}
