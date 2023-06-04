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
        let vc = ExerciseFormConfigurator.resolveAdd()
        vc.modalPresentationStyle = .popover
        viewController?.present(vc, animated: true)
    }
    
    func presentEditExerciseForm(for exercise: Exercise) {
        let vc = ExerciseFormConfigurator.resolveEdit(for: exercise)
        vc.modalPresentationStyle = .popover
        viewController?.present(vc, animated: true)
    }
}
