////
////  
//  ExerciseFormRouter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
////
import UIKit

protocol ExerciseFormPresenterToRouterProtocol: AnyObject {
    var presenter: ExerciseFormRouterToPresenterProtocol? { get set }
    func dismissView(formOutput: ExerciseFormOutput)
}

// MARK: - PresenterToInteractorProtocol
final class ExerciseFormRouter: ExerciseFormPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: ExerciseFormRouterToPresenterProtocol?
    
    func dismissView(formOutput: ExerciseFormOutput) {
        presenter?.dismiss(animated: true) { [weak presenter] in
            presenter?.completionAction(for: formOutput)
        }
    }
}