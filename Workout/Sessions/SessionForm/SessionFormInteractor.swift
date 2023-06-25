//
//  
//  SessionFormInteractor.swift
//  Workout
//
//  Created by Salvador on 6/23/23.
//
//
import Foundation

protocol SessionFormPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var formStyle: FormStyle { get }
    var completionAction: ((SessionFormOutput) -> ()) { get }
}

// MARK: - PresenterToInteractorProtocol
final class SessionFormInteractor: SessionFormPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    private let formModel: SessionFormModel
    
    init(formModel: SessionFormModel) {
        self.formModel = formModel
    }
    
    var formStyle: FormStyle {
        formModel.formStyle
    }
    
    var completionAction: ((SessionFormOutput) -> ()) {
        formModel.completionAction
    }
}
