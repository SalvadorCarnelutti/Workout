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
    func dismissView(formOutput: SessionFormOutput)
}

// MARK: - PresenterToInteractorProtocol
final class SessionFormRouter: BaseRouter, SessionFormPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: SessionFormRouterToPresenterProtocol?
    
    func dismissView(formOutput: SessionFormOutput) {
        presentingViewController?.dismiss(animated: true) { [weak presenter] in
            presenter?.completionAction(for: formOutput)
        }
    }
}
