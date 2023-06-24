//
//  
//  SessionFormInteractor.swift
//  Workout
//
//  Created by Salvador on 6/23/23.
//
//
import Foundation

protocol SessionFormPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class SessionFormInteractor: SessionFormPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
}
