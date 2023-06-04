//
//  
//  AddWorkoutConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import CoreData

final class AddWorkoutConfigurator {
    static func injectDependencies(view: AddWorkoutPresenterToViewProtocol,
                                   interactor: AddWorkoutPresenterToInteractorProtocol,
                                   presenter: AddWorkoutPresenter,
                                   router: AddWorkoutRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewAddWorkout = view
        
        router.viewController = presenter
        presenter.router = router
    }
    
    static func resolve(persistentContainer: NSPersistentContainer) -> AddWorkoutPresenter {
        let presenter = AddWorkoutPresenter()
        let view = AddWorkoutView()
        let interactor = AddWorkoutInteractor(persistentContainer: persistentContainer)
        let router = AddWorkoutRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
