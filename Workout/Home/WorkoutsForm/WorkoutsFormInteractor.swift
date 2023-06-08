//
//  
//  WorkoutsFormInteractor.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//
//
import Foundation

protocol WorkoutsFormPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var formInput: String? { get }
    var formStyle: FormStyle { get }
    var nameValidationBlock: ((String) -> Bool) { get }
    var completionAction: ((String) -> ()) { get }
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsFormInteractor: WorkoutsFormPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    private let formModel: WorkoutFormModel
    
    init(formModel: WorkoutFormModel) {
        self.formModel = formModel
    }
    
    var formInput: String? {
        formModel.formInput
    }
    
    var formStyle: FormStyle {
        formModel.formStyle
    }
    
    var nameValidationBlock: ((String) -> Bool) {
        stringValidationBlock
    }
    
    var completionAction: ((String) -> ()) {
        formModel.completionAction
    }
    
    private func stringValidationBlock(text: String) -> Bool {
        text.trimmingCharacters(in: .whitespaces).isNotEmpty
    }
}
