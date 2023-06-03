//
//  
//  WorkoutsInteractor.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//
//
import Foundation

protocol WorkoutsPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsInteractor: WorkoutsPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
}
