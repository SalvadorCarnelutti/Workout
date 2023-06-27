////
////  
//  ScheduledSessionFormRouter.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
////
import UIKit

protocol ScheduledSessionFormPresenterToRouterProtocol: AnyObject {
    var presenter: ScheduledSessionFormRouterToPresenterProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionFormRouter: ScheduledSessionFormPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: ScheduledSessionFormRouterToPresenterProtocol?
}
