//
//  
//  WorkoutsFormConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//
//
import Foundation

final class WorkoutsFormConfigurator {
    static func injectDependencies(view: WorkoutsFormPresenterToViewProtocol,
                                   interactor: WorkoutsFormPresenterToInteractorProtocol,
                                   presenter: WorkoutsFormPresenter,
                                   router: WorkoutsFormRouter) {
        presenter.interactor = interactor
        interactor.presenter = presenter

        view.presenter = presenter
        presenter.viewWorkoutsForm = view
        
        router.presenter = presenter
        presenter.router = router
    }
    
    static func resolveAdd(completionAction: @escaping ((String) -> Void)) -> WorkoutsFormPresenter {
        let formModel = WorkoutFormModel(formInput: nil, formStyle: .add, completionAction: completionAction)
        
        let presenter = WorkoutsFormPresenter()
        let view = WorkoutsFormView()
        let interactor = WorkoutsFormInteractor(formModel: formModel)
        let router = WorkoutsFormRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
    
    static func resolveEdit(completionAction: @escaping ((String) -> Void)) -> WorkoutsFormPresenter {
        // TOPDO: Change formInput
        let formModel = WorkoutFormModel(formInput: nil, formStyle: .edit, completionAction: completionAction)
        
        let presenter = WorkoutsFormPresenter()
        let view = WorkoutsFormView()
        let interactor = WorkoutsFormInteractor(formModel: formModel)
        let router = WorkoutsFormRouter()

        Self.injectDependencies(view: view,
                                interactor: interactor,
                                presenter: presenter,
                                router: router)

        return presenter
    }
}
