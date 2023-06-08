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
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutFormRouter: WorkoutFormPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: WorkoutFormRouterToPresenterProtocol?
}
