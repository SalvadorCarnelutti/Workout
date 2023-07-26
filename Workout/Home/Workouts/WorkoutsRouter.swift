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

protocol WorkoutsPresenterToRouterProtocol: BaseRouter {
    var presenter: WorkoutsRouterToPresenterProtocol! { get set }
    func pushAddWorkout()
    func pushEditWorkout(for workout: Workout)
    func handleNotificationTap(for workout: Workout)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsRouter: BaseRouter, WorkoutsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: WorkoutsRouterToPresenterProtocol!
    
    func pushAddWorkout() {
        let addWorkoutViewController = WorkoutFormConfigurator.resolveAdd(completionAction: presenter.addCompletionAction)
        addWorkoutViewController.modalPresentationStyle = .popover
        navigationController?.present(addWorkoutViewController, animated: true)
    }

    func pushEditWorkout(for workout: Workout) {
        let editWorkoutViewController = WorkoutConfigurator.resolveEdit(for: workout)
        navigationController?.pushViewController(editWorkoutViewController, animated: true)
    }
    
    func handleNotificationTap(for workout: Workout) {
        let editWorkoutViewController = WorkoutConfigurator.resolveEdit(for: workout)
        navigationController?.pushViewController(editWorkoutViewController, animated: false)
        editWorkoutViewController.handleNotificationTap(for: workout)
    }
}
