//
//  
//  ExerciseFormConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import Foundation

final class ExerciseFormConfigurator {
    static func injectDependencies(view: ExerciseFormPresenterToViewProtocol,
                                   interactor: ExerciseFormPresenterToInteractorProtocol,
                                   presenter: ExerciseFormPresenter,
                                   router: ExerciseFormRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewExerciseForm = view
        
        router.viewController = presenter
        presenter.router = router
    }
    
    static func resolve() -> ExerciseFormPresenter {
        let presenter = ExerciseFormPresenter()
        let view = ExerciseFormView()
        let interactor = ExerciseFormInteractor()
        let router = ExerciseFormRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
