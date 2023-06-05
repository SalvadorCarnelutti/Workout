////
////  
//  AddWorkoutRouter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
////
import UIKit
import CoreData

protocol AddWorkoutPresenterToRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    func presentAddExerciseForm()
    func presentEditExerciseForm(for exercise: Exercise)
}

// MARK: - PresenterToInteractorProtocol
final class AddWorkoutRouter: AddWorkoutPresenterToRouterProtocol {
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    func presentAddExerciseForm() {
        // TODO: Ask the presenter for the interactor add completion action
        let addExerciseFormViewController = ExerciseFormConfigurator.resolveAdd(completionAction: { _ in })
        addExerciseFormViewController.modalPresentationStyle = .popover
        viewController?.present(addExerciseFormViewController, animated: true)
    }
    
    func presentEditExerciseForm(for exercise: Exercise) {
        // TODO: Ask the presenter for the interactor edit completion action
        let editExerciseFormViewController = ExerciseFormConfigurator.resolveEdit(for: exercise, completionAction: { _ in })
        editExerciseFormViewController.modalPresentationStyle = .popover
        viewController?.present(editExerciseFormViewController, animated: true)
    }
}
