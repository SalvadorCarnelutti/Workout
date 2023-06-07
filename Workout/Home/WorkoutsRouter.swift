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
    var viewController: UIViewController? { get set }
    func pushAddWorkout(managedObjectContext: NSManagedObjectContext)
    func pushEditWorkout(for workout: Workout)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsRouter: WorkoutsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    func pushAddWorkout(managedObjectContext: NSManagedObjectContext) {
        let workoutViewController = AddWorkoutConfigurator.resolve(managedObjectContext: managedObjectContext)
        viewController?.navigationController?.pushViewController(workoutViewController, animated: true)
    }

    func pushEditWorkout(for workout: Workout) {
        let workoutViewController = AddWorkoutConfigurator.resolve(workout: workout)
        viewController?.navigationController?.pushViewController(workoutViewController, animated: true)
    }
}
