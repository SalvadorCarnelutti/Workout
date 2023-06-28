//
//  
//  WorkoutFormPresenter.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//
//

import UIKit

protocol WorkoutFormViewToPresenterProtocol: UIViewController {
    var nameEntity: ValidationEntity { get }
    var isButtonEnabled: Bool { get }
    var headerString: String { get }
    var completionString: String { get }
    func viewLoaded()
    func completionAction(for string: String)
}

protocol WorkoutFormRouterToPresenterProtocol: UIViewController {}

final class WorkoutFormPresenter: BaseViewController {
    var viewWorkoutsForm: WorkoutsFormPresenterToViewProtocol!
    var interactor: WorkoutFormPresenterToInteractorProtocol!
    var router: WorkoutFormPresenterToRouterProtocol!
    
    override func loadView() {
        super.loadView()
        view = viewWorkoutsForm
        viewWorkoutsForm.loadView()
    }
}

// MARK: - ViewToPresenterProtocol
extension WorkoutFormPresenter: WorkoutFormViewToPresenterProtocol {
    var nameEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.nameValidationBlock,
                         errorMessage: "Name can't be empty",
                         placeholder: "Name")
    }
    
    var isButtonEnabled: Bool {
        interactor.formStyle == .edit
    }
    
    var headerString: String {
        "Workout"
    }
    
    var completionString: String {
        interactor.formStyle == .add ? "Add" : "Edit"
    }
    
    func viewLoaded() {
        if let formInput = interactor.formInput {
            viewWorkoutsForm.fillFormField(formInput: formInput)
        }
    }
        
    func completionAction(for string: String) {
        dismiss(animated: true) { [weak self] in
            self?.interactor.completionAction(string)
        }
    }
}

// MARK: - RouterToPresenterProtocol
extension WorkoutFormPresenter: WorkoutFormRouterToPresenterProtocol {
    
}
