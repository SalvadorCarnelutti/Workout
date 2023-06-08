////
////  
//  WorkoutsRouter.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//
////
import UIKit
import CoreData

protocol WorkoutsPresenterToRouterProtocol: AnyObject {
    var presenter: WorkoutsRouterToPresenterProtocol? { get set }
    func pushAddWorkout()
    func pushEditWorkout(for workout: Workout)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsRouter: WorkoutsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: WorkoutsRouterToPresenterProtocol?
    
    func pushAddWorkout() {
        guard let presenter = presenter else { return }
        
        let addWorkoutViewController = WorkoutConfigurator.resolveAdd(completionAction: presenter.addCompletionAction)
        addWorkoutViewController.modalPresentationStyle = .popover
        presenter.present(addWorkoutViewController, animated: true)
    }

    func pushEditWorkout(for workout: Workout) {
        guard let presenter = presenter else { return }
        
        let editWorkoutViewController = WorkoutConfigurator.resolveEdit(for: workout)
        presenter.navigationController?.pushViewController(editWorkoutViewController, animated: true)
    }
}
