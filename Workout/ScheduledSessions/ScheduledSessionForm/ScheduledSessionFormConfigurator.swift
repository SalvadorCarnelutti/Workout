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
    static func injectDependencies(view: ScheduledSessionFormPresenterToViewProtocol,
                                   interactor: ScheduledSessionFormPresenterToInteractorProtocol,
                                   presenter: ScheduledSessionFormPresenter,
                                   router: ScheduledSessionFormRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewScheduledSessionForm = view
        
        router.presenter = presenter
        presenter.router = router
    }
    
    static func resolveEdit(for session: Session) -> ScheduledSessionFormPresenter {
        let formModel = ScheduledSessionFormModel(session: session,
                                                  formInput: SessionFormInput(session: session))
        
        let presenter = ScheduledSessionFormPresenter()
        let view = ScheduledSessionFormView()
        let interactor = ScheduledSessionFormInteractor(formModel: formModel)
        let router = ScheduledSessionFormRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
