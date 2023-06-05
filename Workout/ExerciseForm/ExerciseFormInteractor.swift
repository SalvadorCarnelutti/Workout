//
//  
//  ExerciseFormInteractor.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import Foundation
import CoreData

protocol ExerciseFormPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var formInput: FormInput? { get }
    var formStyle: FormStyle { get }
    var nameValidationBlock: ((String?) -> Bool) { get }
    var durationValidationBlock: ((String?) -> Bool) { get }
    var setsValidationBlock: ((String?) -> Bool) { get }
    var repsValidationBlock: ((String?) -> Bool) { get }
    var completionAction: ((FormOutput) -> ()) { get }
}

// MARK: - PresenterToInteractorProtocol
final class ExerciseFormInteractor: ExerciseFormPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?

    private let formModel: FormModel
    
    init(formModel: FormModel) {
        self.formModel = formModel
    }
    
    var formInput: FormInput? {
        formModel.formInput
    }
    
    var formStyle: FormStyle {
        formModel.formStyle
    }
    
    var nameValidationBlock: ((String?) -> Bool) {
        stringValidationBlock
    }
    
    var durationValidationBlock: ((String?) -> Bool) {
        integerValidationBlock
    }
    
    var setsValidationBlock: ((String?) -> Bool) {
        integerValidationBlock
    }
    
    var repsValidationBlock: ((String?) -> Bool) {
        integerValidationBlock
    }
    
    var completionAction: ((FormOutput) -> ()) {
        formModel.completionAction
    }
    
    private func stringValidationBlock(text: String?) -> Bool {
        return text?.isNotEmpty ?? false
    }
    
    private func integerValidationBlock(text: String?) -> Bool {
        guard let text = text, let count = Int(text) else { return false }
        return count > 0
    }
}
