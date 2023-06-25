//
//  
//  ExercisesConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import CoreData

final class ExercisesConfigurator {
    static func injectDependencies(view: ExercisesPresenterToViewProtocol,
                                   interactor: ExercisesPresenterToInteractorProtocol,
                                   presenter: ExercisesPresenter,
                                   router: ExercisesRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewExercises = view
        
        router.presenter = presenter
        presenter.router = router
    }
        
    static func resolveEdit(for workout: Workout) -> ExercisesPresenter {
        let presenter = ExercisesPresenter()
        let view = ExercisesView()
        let interactor = ExercisesInteractor(workout: workout)
        let router = ExercisesRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
