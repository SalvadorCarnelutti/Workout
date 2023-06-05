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

enum formStyle {
    case add
    case edit
}

protocol ExerciseFormPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var formStyle: formStyle { get set }
    func completionAction()
}

// MARK: - PresenterToInteractorProtocol
final class ExerciseFormInteractor: ExerciseFormPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    var formStyle: formStyle
    
    init(formStyle: formStyle) {
        self.formStyle = formStyle
    }
    
    func completionAction() {
    }
    
    static func nameValidationBlock(text: String?) -> Bool {
        return text?.isNotEmpty ?? false
    }
    
    static func durationValidationBlock(text: String?) -> Bool {
        guard let text = text, let count = Int(text) else { return false }
        return count > 0
    }
}
