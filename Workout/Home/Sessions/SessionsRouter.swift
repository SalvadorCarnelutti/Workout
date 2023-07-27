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
    var presenter: SessionsRouterToPresenterProtocol! { get set }
    func presentAddSessionForm()
    func presentEditSessionForm(for session: Session)
}

// MARK: - PresenterToInteractorProtocol
final class SessionsRouter: BaseRouter, SessionsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: SessionsRouterToPresenterProtocol!
    
    func presentAddSessionForm() {
        let addSessionFormViewController = SessionFormConfigurator.resolveAdd(completionAction: presenter.addCompletionAction)
        addSessionFormViewController.modalPresentationStyle = .popover
        navigationController?.present(addSessionFormViewController, animated: true)
    }
    
    func presentEditSessionForm(for session: Session) {
        
        let editSessionFormViewController = SessionFormConfigurator.resolveEdit(for: session) { [weak self] formOutput in
            guard let presenter = self?.presenter else { return }
            
            presenter.editCompletionAction(for: session, formOutput: formOutput)
        }
        
        editSessionFormViewController.modalPresentationStyle = .popover
        navigationController?.present(editSessionFormViewController, animated: true)
    }
}
