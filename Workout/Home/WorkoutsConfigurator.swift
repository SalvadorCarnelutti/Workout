//
//  
//  WorkoutsConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//
//
import Foundation
import CoreData

final class WorkoutsConfigurator {
    static func injectDependencies(view: WorkoutsPresenterToViewProtocol,
                                   interactor: WorkoutsPresenterToInteractorProtocol,
                                   presenter: WorkoutsPresenter,
                                   router: WorkoutsRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewWorkouts = view
        
        router.presenter = presenter
        presenter.router = router
    }
    
    static func resolve() -> WorkoutsPresenter {
        let presenter = WorkoutsPresenter()
        let view = WorkoutsView()
        let interactor = WorkoutsInteractor(persistentContainer: NSPersistentContainer(name: "Workout"))
        let router = WorkoutsRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
