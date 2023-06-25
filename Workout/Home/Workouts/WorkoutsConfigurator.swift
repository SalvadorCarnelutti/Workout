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
        presenter.viewWorkout = view
        
        router.presenter = presenter
        presenter.router = router
    }
    
    static func resolveFor(managedObjectContext: NSManagedObjectContext) -> WorkoutsPresenter {
        let presenter = WorkoutsPresenter()
        let view = WorkoutsView()
        let interactor = WorkoutsInteractor(managedObjectContext: managedObjectContext)
        let router = WorkoutsRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
