////
////  
//  ScheduledSessionsRouter.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//
////
import UIKit

protocol ScheduledSessionsPresenterToRouterProtocol: AnyObject {
    var presenter: ScheduledSessionsRouterToPresenterProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionsRouter: ScheduledSessionsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: ScheduledSessionsRouterToPresenterProtocol?
}
