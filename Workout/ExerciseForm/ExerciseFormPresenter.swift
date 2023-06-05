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
    var headerString: String { get }
    var completionString: String { get }
    func completionAction(for formOutput: FormOutput)
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
                         errorMessage: "Duration must be not empty and positive",
                         placeholder: "Duration")
    }
    
    var setsEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.durationValidationBlock,
                         errorMessage: "Set must be not empty and positive",
                         placeholder: "Set count")
    }
    
    var repsEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.durationValidationBlock,
                         errorMessage: "Rep must be not empty and positive",
                         placeholder: "Rep count")
    }
    
    var headerString: String {
        interactor.formStyle == .add ? "Add exercise to current workout" : "Edit current exercise"
    }
    
    var completionString: String {
        interactor.formStyle == .add ? "Add" : "Edit"
    }
    
    func completionAction(for formOutput: FormOutput) {
        dismiss(animated: true) { [weak self] in
            self?.interactor.completionAction(formOutput)
        }
    }
}
