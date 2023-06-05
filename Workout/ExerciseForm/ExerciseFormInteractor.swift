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

enum FormStyle {
    case add
    case edit
}

struct FormOutput {
    var name: String
    var duration: Int
    var sets: Int
    var reps: Int
}

protocol ExerciseFormPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var formStyle: FormStyle { get set }
    var nameValidationBlock: ((String?) -> Bool) { get }
    var durationValidationBlock: ((String?) -> Bool) { get }
    var setsValidationBlock: ((String?) -> Bool) { get }
    var repsValidationBlock: ((String?) -> Bool) { get }
    var completionAction: ((FormOutput) -> ()) { get set }
}

// MARK: - PresenterToInteractorProtocol
final class ExerciseFormInteractor: ExerciseFormPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    var formStyle: FormStyle
    var completionAction: ((FormOutput) -> ())
    
    init(formStyle: FormStyle, completionAction: @escaping ((FormOutput) -> ())) {
        self.formStyle = formStyle
        self.completionAction = completionAction
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
    
    private func stringValidationBlock(text: String?) -> Bool {
        return text?.isNotEmpty ?? false
    }
    
    private func integerValidationBlock(text: String?) -> Bool {
        guard let text = text, let count = Int(text) else { return false }
        return count > 0
    }
}
