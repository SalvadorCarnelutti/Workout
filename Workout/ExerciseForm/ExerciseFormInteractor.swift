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
    var presenter: BaseViewProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class ExerciseFormInteractor: ExerciseFormPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    
    static func nameValidationBlock(text: String?) -> Bool {
        return text?.isNotEmpty ?? false
    }
    
    static func durationValidationBlock(text: String?) -> Bool {
        guard let text = text, let count = Int(text) else { return false }
        return count > 0
    }
}
