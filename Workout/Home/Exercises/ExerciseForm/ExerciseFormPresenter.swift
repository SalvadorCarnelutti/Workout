//
//  
//  ExerciseFormPresenter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//

import UIKit

protocol ExerciseFormViewToPresenterProtocol: AnyObject {
    var view: ExerciseFormPresenterToViewProtocol! { get set }
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

protocol ExerciseFormRouterToPresenterProtocol: AnyObject {
    func completionAction(for formOutput: ExerciseFormOutput)
}

typealias ExerciseFormPresenterProtocol = ExerciseFormViewToPresenterProtocol & ExerciseFormRouterToPresenterProtocol

final class ExerciseFormPresenter: ExerciseFormPresenterProtocol {
    weak var view: ExerciseFormPresenterToViewProtocol!
    let interactor: ExerciseFormPresenterToInteractorProtocol
    let router: ExerciseFormPresenterToRouterProtocol
    
    init(interactor: ExerciseFormPresenterToInteractorProtocol, router: ExerciseFormPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        router.presenter = self
    }
}

// MARK: - ViewToPresenterProtocol
extension ExerciseFormPresenter {
    var nameEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.nameValidationBlock,
                         errorMessage: String(localized: "Name can't be empty"),
                         placeholder: String(localized: "Name"))
    }
    
    var durationEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.durationValidationBlock,
                         errorMessage: String(localized: "Duration must be positive"),
                         placeholder: String(localized: "Minutes duration (Optional)"))
    }
    
    var setsEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.setsValidationBlock,
                         errorMessage: String(localized: "Set must be not empty and positive"),
                         placeholder: String(localized: "Set count"))
    }
    
    var repsEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.repsValidationBlock,
                         errorMessage: String(localized: "Rep must be not empty and positive"),
                         placeholder: String(localized: "Rep count"))
    }
    
    var isCompletionButtonEnabled: Bool {
        interactor.formStyle == .edit
    }
    
    var headerString: String { String(localized: "Exercise") }
    
    var completionButtonString: String {
        interactor.formStyle == .add ? String(localized: "Add") : String(localized: "Edit")
    }
    
    func viewLoaded() {
        if let exerciseFormInput = interactor.formInput {
            view.fillFormFields(formInput: exerciseFormInput)
        }
    }
    
    func completionButtonTapped(for formOutput: ExerciseFormOutput) {
        router.dismissView(formOutput: formOutput)
    }
}

// MARK: - RouterToPresenterProtocol
extension ExerciseFormPresenter {
    func completionAction(for formOutput: ExerciseFormOutput) {
        interactor.completionAction(formOutput)
    }
}
