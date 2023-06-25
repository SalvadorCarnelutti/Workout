//
//  
//  ScheduledSessionsInteractor.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//
//
import Foundation

protocol ScheduledSessionsPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionsInteractor: ScheduledSessionsPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
}
