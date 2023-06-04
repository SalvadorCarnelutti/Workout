////
////  
//  AddWorkoutRouter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
////
import UIKit

protocol AddWorkoutPresenterToRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    func presentExerciseForm()
}

// MARK: - PresenterToInteractorProtocol
final class AddWorkoutRouter: AddWorkoutPresenterToRouterProtocol {
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    func presentExerciseForm() {
        let vc = ExerciseFormConfigurator.resolve()
        vc.modalPresentationStyle = .popover
        viewController?.present(vc, animated: true)
    }
}
