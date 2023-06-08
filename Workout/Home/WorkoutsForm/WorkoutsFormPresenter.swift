//
//  
//  WorkoutsFormPresenter.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//
//

import UIKit

protocol WorkoutsFormViewToPresenterProtocol: UIViewController {
    var formInput: String? { get }
    var nameEntity: ValidationEntity { get }
    var isbuttonEnabled: Bool { get }
    var headerString: String { get }
    var completionString: String { get }
    func completionAction(for string: String)
}

protocol WorkoutsFormRouterToPresenterProtocol: UIViewController {}

final class WorkoutsFormPresenter: BaseViewController {
    var viewWorkoutsForm: WorkoutsFormPresenterToViewProtocol!
    var interactor: WorkoutsFormPresenterToInteractorProtocol!
    var router: WorkoutsFormPresenterToRouterProtocol!
    
    override func loadView() {
        super.loadView()
        view = viewWorkoutsForm
        viewWorkoutsForm.loadView()
    }
}

// MARK: - ViewToPresenterProtocol
extension WorkoutsFormPresenter: WorkoutsFormViewToPresenterProtocol {
    var formInput: String? {
        interactor.formInput
    }
    
    var nameEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.nameValidationBlock,
                         errorMessage: "Name can't be empty",
                         placeholder: "Name")
    }
    
    var isbuttonEnabled: Bool {
        interactor.formStyle == .edit
    }
    
    var headerString: String {
        "Workout"
    }
    
    var completionString: String {
        interactor.formStyle == .add ? "Add" : "Edit"
    }
        
    func completionAction(for string: String) {
        dismiss(animated: true) { [weak self] in
            self?.interactor.completionAction(string)
        }
    }
}

// MARK: - RouterToPresenterProtocol
extension WorkoutsFormPresenter: WorkoutsFormRouterToPresenterProtocol {
    
}
