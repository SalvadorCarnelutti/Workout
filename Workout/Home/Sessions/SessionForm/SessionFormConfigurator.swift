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
    static func resolveAdd(completionAction: @escaping (SessionFormOutput) -> ()) -> SessionFormViewController {
        let formModel = SessionFormModel(formInput: nil, formStyle: .add, completionAction: completionAction)
        
        let interactor = SessionFormInteractor(formModel: formModel)
        let router = SessionFormRouter()
        
        let presenter = SessionFormPresenter(interactor: interactor, router: router)
        
        let view = SessionFormViewController(presenter: presenter)
        router.presentation = { view }
        
        return view
    }
    
    static func resolveEdit(for session: Session, completionAction: @escaping (SessionFormOutput) -> ()) -> SessionFormViewController {
        let formModel = SessionFormModel(formInput: SessionFormInput(session: session),
                                         formStyle: .edit,
                                         completionAction: completionAction)
        
        let interactor = SessionFormInteractor(formModel: formModel)
        let router = SessionFormRouter()
        
        let presenter = SessionFormPresenter(interactor: interactor, router: router)
        
        let view = SessionFormViewController(presenter: presenter)
        router.presentation = { view }
        
        return view
    }
}
