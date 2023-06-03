////
////  
//  WorkoutsRouter.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//
////
import UIKit

protocol WorkoutsPresenterToRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    func pushAddWorkout()
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsRouter: WorkoutsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    func pushAddWorkout() {
        viewController?.navigationController?.pushViewController(AddWorkoutConfigurator.resolve(), animated: true)
    }
}
