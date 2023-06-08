//
//  
//  WorkoutConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import CoreData

final class WorkoutConfigurator {
    static func injectDependencies(view: WorkoutPresenterToViewProtocol,
                                   interactor: WorkoutPresenterToInteractorProtocol,
                                   presenter: WorkoutPresenter,
                                   router: WorkoutRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewAddWorkout = view
        
        router.presenter = presenter
        presenter.router = router
    }
    
    static func resolveAdd(completionAction: @escaping ((String) -> Void)) -> WorkoutFormPresenter {
        WorkoutFormConfigurator.resolveAdd(completionAction: completionAction)
    }
    
    static func resolveEdit(for workout: Workout) -> WorkoutPresenter {
        let presenter = WorkoutPresenter()
        let view = WorkoutView()
        let interactor = WorkoutInteractor(workout: workout)
        let router = WorkoutRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
