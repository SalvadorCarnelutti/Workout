//
//  
//  SessionsConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/21/23.
//
//
import Foundation

final class SessionsConfigurator {
    static func injectDependencies(view: SessionsPresenterToViewProtocol,
                                   interactor: SessionsPresenterToInteractorProtocol,
                                   presenter: SessionsPresenter,
                                   router: SessionsRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewSessions = view
        
        router.presenter = presenter
        presenter.router = router
    }
    
    static func resolve(for workout: Workout) -> SessionsPresenter {
        let presenter = SessionsPresenter()
        let view = SessionsView()
        let interactor = SessionsInteractor(workout: workout)
        let router = SessionsRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
