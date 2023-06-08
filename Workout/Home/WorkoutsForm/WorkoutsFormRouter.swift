////
////  
//  WorkoutsFormRouter.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//
////
import UIKit

protocol WorkoutsFormPresenterToRouterProtocol: AnyObject {
    var presenter: WorkoutsFormRouterToPresenterProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsFormRouter: WorkoutsFormPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: WorkoutsFormRouterToPresenterProtocol?
}
