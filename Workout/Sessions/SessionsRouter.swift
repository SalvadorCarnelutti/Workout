////
////  
//  SessionsRouter.swift
//  Workout
//
//  Created by Salvador on 6/21/23.
//
////
import UIKit

protocol SessionsPresenterToRouterProtocol: AnyObject {
    var presenter: SessionsRouterToPresenterProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class SessionsRouter: SessionsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: SessionsRouterToPresenterProtocol?
}
