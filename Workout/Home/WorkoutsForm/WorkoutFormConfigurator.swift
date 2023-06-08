//
//  
//  WorkoutFormConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//
//
import Foundation

final class WorkoutFormConfigurator {
    static func injectDependencies(view: WorkoutsFormPresenterToViewProtocol,
                                   interactor: WorkoutFormPresenterToInteractorProtocol,
                                   presenter: WorkoutFormPresenter,
                                   router: WorkoutFormRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewWorkoutsForm = view
        
        router.presenter = presenter
        presenter.router = router
    }
    
    static func resolveAdd(completionAction: @escaping ((String) -> Void)) -> WorkoutFormPresenter {
        let formModel = WorkoutFormModel(formInput: nil, formStyle: .add, completionAction: completionAction)
        
        let presenter = WorkoutFormPresenter()
        let view = WorkoutFormView()
        let interactor = WorkoutFormInteractor(formModel: formModel)
        let router = WorkoutFormRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
    
    static func resolveEdit(completionAction: @escaping ((String) -> Void)) -> WorkoutFormPresenter {
        // TOPDO: Change formInput
        let formModel = WorkoutFormModel(formInput: nil, formStyle: .edit, completionAction: completionAction)
        
        let presenter = WorkoutFormPresenter()
        let view = WorkoutFormView()
        let interactor = WorkoutFormInteractor(formModel: formModel)
        let router = WorkoutFormRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
