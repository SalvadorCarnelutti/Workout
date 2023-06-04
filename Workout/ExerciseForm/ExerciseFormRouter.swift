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
    var viewController: UIViewController? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class ExerciseFormRouter: ExerciseFormPresenterToRouterProtocol {
    // MARK: - Properties
    weak var viewController: UIViewController?
}
