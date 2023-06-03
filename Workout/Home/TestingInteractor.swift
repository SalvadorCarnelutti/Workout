//
//  
//  TestingInteractor.swift
//  Workout
//
//  Created by Salvador on 5/31/23.
//
//
import Foundation

protocol TestingPresenterToInteractorProtocol: AnyObject {
    var presenter: UIViewController? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class TestingInteractor: TestingPresenterToInteractorProtocol {
    weak var presenter: UIViewController?
}
