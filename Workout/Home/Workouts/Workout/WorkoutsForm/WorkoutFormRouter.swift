////
////  
//  WorkoutFormRouter.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//
////
import UIKit

protocol WorkoutFormPresenterToRouterProtocol: AnyObject {
    var presenter: WorkoutFormRouterToPresenterProtocol? { get set }
    func dismissView(newName: String)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutFormRouter: BaseRouter, WorkoutFormPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: WorkoutFormRouterToPresenterProtocol?
    
    func dismissView(newName: String) {
        presentingViewController?.dismiss(animated: true) { [weak presenter] in
            presenter?.completionAction(for: newName)
        }
    }
}
