////
////  
//  SessionFormRouter.swift
//  Workout
//
//  Created by Salvador on 6/23/23.
//
////
import UIKit

protocol SessionFormPresenterToRouterProtocol: AnyObject {
    var presenter: SessionFormRouterToPresenterProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class SessionFormRouter: SessionFormPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: SessionFormRouterToPresenterProtocol?
}
