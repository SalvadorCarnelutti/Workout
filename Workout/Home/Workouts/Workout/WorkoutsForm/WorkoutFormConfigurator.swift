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
    static func resolveAdd(completionAction: @escaping ((String) -> Void)) -> WorkoutFormViewController {
        let formModel = WorkoutFormModel(formInput: nil, formStyle: .add, completionAction: completionAction)
        
        let interactor = WorkoutFormInteractor(formModel: formModel)
        let router = WorkoutFormRouter()
        
        let presenter = WorkoutFormPresenter(interactor: interactor, router: router)
        
        let view = WorkoutFormViewController(presenter: presenter)
        router.presentation = { view }

        return view
    }
    
    static func resolveEdit(for workoutName: String, completionAction: @escaping ((String) -> Void)) -> WorkoutFormViewController {
        let formModel = WorkoutFormModel(formInput: workoutName, formStyle: .edit, completionAction: completionAction)
        
        let interactor = WorkoutFormInteractor(formModel: formModel)
        let router = WorkoutFormRouter()
        
        let presenter = WorkoutFormPresenter(interactor: interactor, router: router)
        
        let view = WorkoutFormViewController(presenter: presenter)
        router.presentation = { view }

        return view
    }
}
