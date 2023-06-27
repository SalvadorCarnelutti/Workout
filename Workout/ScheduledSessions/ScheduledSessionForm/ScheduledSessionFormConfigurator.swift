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
    
    static func resolve() -> ScheduledSessionFormPresenter {
        let presenter = ScheduledSessionFormPresenter()
        let view = ScheduledSessionFormView()
        let interactor = ScheduledSessionFormInteractor()
        let router = ScheduledSessionFormRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
