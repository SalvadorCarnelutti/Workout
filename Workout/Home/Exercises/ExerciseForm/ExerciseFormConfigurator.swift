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
    static func resolveAdd(completionAction: @escaping (ExerciseFormOutput) -> ()) -> ExerciseFormViewController {
        let formModel = ExerciseFormModel(formInput: nil, formStyle: .add, completionAction: completionAction)
        
        let interactor = ExerciseFormInteractor(formModel: formModel)
        let router = ExerciseFormRouter()
        
        let presenter = ExerciseFormPresenter(interactor: interactor, router: router)
        
        let view = ExerciseFormViewController(presenter: presenter)
        router.navigation = { view }

        return view
    }
    
    static func resolveEdit(for exercise: Exercise, completionAction: @escaping (ExerciseFormOutput) -> ()) -> ExerciseFormViewController {
        let formModel = ExerciseFormModel(formInput: ExerciseFormInput(exercise: exercise), formStyle: .edit, completionAction: completionAction)

        let interactor = ExerciseFormInteractor(formModel: formModel)
        let router = ExerciseFormRouter()
        
        let presenter = ExerciseFormPresenter(interactor: interactor, router: router)
        
        let view = ExerciseFormViewController(presenter: presenter)
        router.navigation = { view }

        return view
    }
}
