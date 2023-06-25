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
    func presentEditSessionForm(for session: Session)
}

// MARK: - PresenterToInteractorProtocol
final class SessionsRouter: SessionsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: SessionsRouterToPresenterProtocol?
    
    func presentAddSessionForm() {
        guard let presenter = presenter else { return }
        
        let addSessionFormViewController = SessionFormConfigurator.resolveAdd(completionAction: presenter.addCompletionAction)
        addSessionFormViewController.modalPresentationStyle = .popover
        presenter.present(addSessionFormViewController, animated: true)
    }
    
    func presentEditSessionForm(for session: Session) {
        guard let presenter = presenter else { return }
        
        let editSessionFormViewController = SessionFormConfigurator.resolveEdit(for: session) { [weak self] formOutput in
            self?.presenter?.editCompletionAction(for: session, formOutput: formOutput)
        }
        
        editSessionFormViewController.modalPresentationStyle = .popover
        presenter.present(editSessionFormViewController, animated: true)
    }
}
