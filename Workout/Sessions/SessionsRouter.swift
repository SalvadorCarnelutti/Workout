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
    func presentAddSessionForm()
    func presentEditSessionForm()
}

// MARK: - PresenterToInteractorProtocol
final class SessionsRouter: SessionsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: SessionsRouterToPresenterProtocol?
    
    func presentAddSessionForm() {
        guard let presenter = presenter else { return }
        
        let addSessionFormViewController = SessionFormConfigurator.resolve()
        addSessionFormViewController.modalPresentationStyle = .popover
        presenter.present(addSessionFormViewController, animated: true)
    }
    
    func presentEditSessionForm() {
        guard let presenter = presenter else { return }
        
        
    }
}
