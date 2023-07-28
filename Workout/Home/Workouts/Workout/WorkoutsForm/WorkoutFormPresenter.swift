//
//  
//  WorkoutFormPresenter.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//
//

import UIKit

protocol WorkoutFormViewToPresenterProtocol: AnyObject {
    var view: WorkoutsFormPresenterToViewProtocol! { get set }
    var nameEntity: ValidationEntity { get }
    var isButtonEnabled: Bool { get }
    var headerString: String { get }
    var completionString: String { get }
    func viewLoaded()
    func completionButtonTapped(for string: String)
}

protocol WorkoutFormRouterToPresenterProtocol: AnyObject {
    func completionAction(for string: String)
}

typealias WorkoutFormPresenterProtocol = WorkoutFormViewToPresenterProtocol & WorkoutFormRouterToPresenterProtocol

final class WorkoutFormPresenter: WorkoutFormPresenterProtocol {
    weak var view: WorkoutsFormPresenterToViewProtocol!
    let interactor: WorkoutFormPresenterToInteractorProtocol
    let router: WorkoutFormPresenterToRouterProtocol
    
    init(interactor: WorkoutFormPresenterToInteractorProtocol, router: WorkoutFormPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        router.presenter = self
    }
}

// MARK: - ViewToPresenterProtocol
extension WorkoutFormPresenter {
    var nameEntity: ValidationEntity {
        ValidationEntity(validationBlock: interactor.nameValidationBlock,
                         errorMessage: String(localized: "Name can't be empty"),
                         placeholder: String(localized: "Name"))
    }
    
    var isButtonEnabled: Bool { interactor.formStyle == .edit }
    
    var headerString: String { String(localized: "Workout") }
    
    var completionString: String {
        interactor.formStyle == .add ? String(localized: "Add") : String(localized: "Edit")
    }
    
    func viewLoaded() {
        if let formInput = interactor.formInput {
            view.fillFormField(formInput: formInput)
        }
    }
        
    func completionButtonTapped(for string: String) {
        router.dismissView(newName: string)
    }
}

// MARK: - RouterToPresenterProtocol
extension WorkoutFormPresenter {
    func completionAction(for string: String) {
        interactor.completionAction(string)
    }
}
