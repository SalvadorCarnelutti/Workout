//
//  
//  ScheduledSessionFormConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
//
import Foundation

final class ScheduledSessionFormConfigurator {
    static func resolveEdit(for session: Session) -> ScheduledSessionFormViewController {
        let formModel = ScheduledSessionFormModel(session: session,
                                                  formInput: SessionFormInput(session: session))
        
        let interactor = ScheduledSessionFormInteractor(formModel: formModel)
        let router = ScheduledSessionFormRouter()
        
        let presenter = ScheduledSessionFormPresenter(interactor: interactor, router: router)
        
        let view = ScheduledSessionFormViewController(presenter: presenter)
        router.navigation = { view }
        
        return view
    }
}
