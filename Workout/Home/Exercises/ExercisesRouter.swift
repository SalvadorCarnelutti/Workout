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
    var presenter: ExercisesRouterToPresenterProtocol! { get set }
    func presentAddExerciseForm()
    func presentEditExerciseForm(for exercise: Exercise)
}

// MARK: - PresenterToInteractorProtocol
final class ExercisesRouter: BaseRouter, ExercisesPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: ExercisesRouterToPresenterProtocol!
    
    func presentAddExerciseForm() {
        let addExerciseFormViewController = ExerciseFormConfigurator.resolveAdd(completionAction: presenter.addCompletionAction)
        addExerciseFormViewController.modalPresentationStyle = .popover
        navigationController?.present(addExerciseFormViewController, animated: true)
    }
    
    func presentEditExerciseForm(for exercise: Exercise) {
        let editExerciseFormViewController = ExerciseFormConfigurator.resolveEdit(for: exercise) { [weak self] formOutput in
            guard let presenter = self?.presenter else { return }
            
            presenter.editCompletionAction(for: exercise, formOutput: formOutput)
        }
        
        editExerciseFormViewController.modalPresentationStyle = .popover
        navigationController?.present(editExerciseFormViewController, animated: true)
    }
}
