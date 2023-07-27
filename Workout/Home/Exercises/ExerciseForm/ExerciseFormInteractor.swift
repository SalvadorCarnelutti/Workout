//
//  
//  ExerciseFormInteractor.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import Foundation

protocol ExerciseFormPresenterToInteractorProtocol: AnyObject {
    var formInput: ExerciseFormInput? { get }
    var formStyle: FormStyle { get }
    var nameValidationBlock: ((String) -> Bool) { get }
    var durationValidationBlock: ((String) -> Bool) { get }
    var setsValidationBlock: ((String) -> Bool) { get }
    var repsValidationBlock: ((String) -> Bool) { get }
    var completionAction: ((ExerciseFormOutput) -> ()) { get }
}

// MARK: - PresenterToInteractorProtocol
final class ExerciseFormInteractor: ExerciseFormPresenterToInteractorProtocol {
    private let formModel: ExerciseFormModel
    
    init(formModel: ExerciseFormModel) {
        self.formModel = formModel
    }
    
    var formInput: ExerciseFormInput? {
        formModel.formInput
    }
    
    var formStyle: FormStyle {
        formModel.formStyle
    }
    
    var nameValidationBlock: ((String) -> Bool) {
        stringValidationBlock
    }
    
    var durationValidationBlock: ((String) -> Bool) {
        optionalIntegerValidationBlock
    }
    
    var setsValidationBlock: ((String) -> Bool) {
        integerValidationBlock
    }
    
    var repsValidationBlock: ((String) -> Bool) {
        integerValidationBlock
    }
    
    var completionAction: ((ExerciseFormOutput) -> ()) {
        formModel.completionAction
    }
    
    private func stringValidationBlock(text: String) -> Bool {
        text.trimmingCharacters(in: .whitespaces).isNotEmpty
    }
    
    private func integerValidationBlock(text: String) -> Bool {
        Int(text) ?? 0 > 0
    }
    
    private func optionalIntegerValidationBlock(text: String) -> Bool {
        text.isEmpty || integerValidationBlock(text: text)
    }
}
