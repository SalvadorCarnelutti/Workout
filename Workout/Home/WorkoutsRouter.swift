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
    func pushAddWorkout()
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsRouter: WorkoutsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    func pushAddWorkout() {
        viewController?.navigationController?.pushViewController(AddWorkoutConfigurator.resolve(persistentContainer: NSPersistentContainer(name: "Workout")), animated: true)
    }
}
