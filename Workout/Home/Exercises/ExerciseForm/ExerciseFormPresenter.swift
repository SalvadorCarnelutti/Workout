//
//  
//  ExerciseFormPresenter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//

import UIKit

protocol ExerciseFormViewToPresenterProtocol: UIViewController {
    var nameEntity: ValidationEntity { get }
    var durationEntity: ValidationEntity { get }
    var setsEntity: ValidationEntity { get }
    var repsEntity: ValidationEntity { get }
    var isCompletionButtonEnabled: Bool { get }
    var headerString: String { get }
    var completionButtonString: String { get }
    func viewLoaded()
    func completionButtonTapped(for formOutput: ExerciseFormOutput)
}

protocol ExerciseFormRouterToPresenterProtocol: UIViewController {
    func completionAction(for formOutput: ExerciseFormOutput)
}

final class ExerciseFormPresenter: BaseViewController {
    var viewExerciseForm: ExerciseFormPresenterToViewProtocol!
    var interactor: ExerciseFormPresenterToInteractorProtocol!
    var router: ExerciseFormPresenterToRouterProtocol!
    
    override func loadView() {
        super.loadView()
        view = viewExerciseForm
        viewExerciseForm.loadView()
    }
}

// MARK: - ViewToPresenterProtocol
extension ExerciseFormPresenter: ExerciseFormViewToPresenterProtocol {
    var nameEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.nameValidationBlock,
                         errorMessage: "Name can't be empty",
                         placeholder: "Name")
    }
    
    var durationEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.durationValidationBlock,
                         errorMessage: "Duration must be positive",
                         placeholder: "Minutes duration (Optional)")
    }
    
    var setsEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.setsValidationBlock,
                         errorMessage: "Set must be not empty and positive",
                         placeholder: "Set count")
    }
    
    var repsEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.repsValidationBlock,
                         errorMessage: "Rep must be not empty and positive",
                         placeholder: "Rep count")
    }
    
    var isCompletionButtonEnabled: Bool {
        interactor.formStyle == .edit
    }
    
    var headerString: String {
        "Exercise"
    }
    
    var completionButtonString: String {
        interactor.formStyle == .add ? "Add" : "Edit"
    }
    
    func viewLoaded() {
        if let exerciseFormInput = interactor.formInput {
            viewExerciseForm.fillFormFields(formInput: exerciseFormInput)
        }
    }
    
    func completionButtonTapped(for formOutput: ExerciseFormOutput) {
        router.dismissView(formOutput: formOutput)
    }
}

// MARK: - RouterToPresenterProtocol
extension ExerciseFormPresenter: ExerciseFormRouterToPresenterProtocol {
    func completionAction(for formOutput: ExerciseFormOutput) {
        interactor.completionAction(formOutput)
    }
}
