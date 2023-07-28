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
    func pushEditSessionForm(for session: Session)
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionsRouter: BaseRouter, ScheduledSessionsPresenterToRouterProtocol {
    func pushEditSessionForm(for session: Session) {
        let editScheduledSessionFormViewController = ScheduledSessionFormConfigurator.resolveEdit(for: session)        
        navigationController?.pushViewController(editScheduledSessionFormViewController, animated: true)
    }
}
