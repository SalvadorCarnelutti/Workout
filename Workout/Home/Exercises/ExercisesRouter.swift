////
////  
//  ExercisesRouter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
////
import UIKit
import CoreData

protocol ExercisesPresenterToRouterProtocol: AnyObject {
    var presenter: ExercisesRouterToPresenterProtocol? { get set }
    func presentAddExerciseForm()
    func presentEditExerciseForm(for exercise: Exercise)
}

// MARK: - PresenterToInteractorProtocol
final class ExercisesRouter: ExercisesPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: ExercisesRouterToPresenterProtocol?
    
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