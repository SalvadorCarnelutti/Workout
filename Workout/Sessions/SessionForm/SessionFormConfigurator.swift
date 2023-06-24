//
//  
//  SessionFormConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/23/23.
//
//
import Foundation

final class SessionFormConfigurator {
    static func injectDependencies(view: SessionFormPresenterToViewProtocol,
                                   interactor: SessionFormPresenterToInteractorProtocol,
                                   presenter: SessionFormPresenter,
                                   router: SessionFormRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewSessionForm = view
        
        router.presenter = presenter
        presenter.router = router
    }
    
    static func resolve() -> SessionFormPresenter {
        let presenter = SessionFormPresenter()
        let view = SessionFormView()
        let interactor = SessionFormInteractor()
        let router = SessionFormRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
