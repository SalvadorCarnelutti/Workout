//
//  
//  AppSettingsInteractor.swift
//  Workout
//
//  Created by Salvador on 7/7/23.
//
//
import Foundation

protocol AppSettingsPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class AppSettingsInteractor: AppSettingsPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
}
