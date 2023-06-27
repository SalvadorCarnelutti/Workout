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
    func pushEditSessionForm(for session: Session)
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionsRouter: ScheduledSessionsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: ScheduledSessionsRouterToPresenterProtocol?
    
    func pushEditSessionForm(for session: Session) {
        guard let presenter = presenter else { return }
        
        let editScheduledSessionFormViewController = ScheduledSessionFormConfigurator.resolveEdit(for: session)        
        presenter.navigationController?.pushViewController(editScheduledSessionFormViewController, animated: true)
    }
}
