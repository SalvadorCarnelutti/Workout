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
    func presentEditSessionForm(for session: Session)
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionsRouter: ScheduledSessionsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: ScheduledSessionsRouterToPresenterProtocol?
    
    func presentEditSessionForm(for session: Session) {
        guard let presenter = presenter else { return }
        
        let editSessionFormViewController = SessionFormConfigurator.resolveEdit(for: session) { [weak self] formOutput in
            self?.presenter?.editCompletionAction(for: session, formOutput: formOutput)
        }
        
        editSessionFormViewController.modalPresentationStyle = .popover
        presenter.present(editSessionFormViewController, animated: true)
    }
}
