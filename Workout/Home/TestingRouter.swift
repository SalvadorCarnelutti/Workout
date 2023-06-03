//
//  
//  TestingRouter.swift
//  Workout
//
//  Created by Salvador on 5/31/23.
//
//
import Foundation

protocol TestingPresenterToRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class TestingRouter: TestingPresenterToRouterrProtocol {
    // MARK: - Properties
    weak var viewController: UIViewController?
}
