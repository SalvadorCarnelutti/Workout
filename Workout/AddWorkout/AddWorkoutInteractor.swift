//
//  
//  AddWorkoutInteractor.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import Foundation

protocol AddWorkoutPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class AddWorkoutInteractor: AddWorkoutPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    
    private var exercises = [Exercise]()
}
