//
//  
//  ScheduledSessionsConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//
//
import Foundation

final class ScheduledSessionsConfigurator {
    static func injectDependencies(view: ScheduledSessionsPresenterToViewProtocol,
                                   interactor: ScheduledSessionsPresenterToInteractorProtocol,
                                   presenter: ScheduledSessionsPresenter,
                                   router: ScheduledSessionsRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewScheduledSessions = view
        
        router.presenter = presenter
        presenter.router = router
    }
    
    static func resolve() -> ScheduledSessionsPresenter {
        let presenter = ScheduledSessionsPresenter()
        let view = ScheduledSessionsView()
        let interactor = ScheduledSessionsInteractor()
        let router = ScheduledSessionsRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
