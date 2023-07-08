////
////  
//  AppSettingsRouter.swift
//  Workout
//
//  Created by Salvador on 7/7/23.
//
////
import UIKit

protocol AppSettingsPresenterToRouterProtocol: AnyObject {
    var presenter: AppSettingsRouterToPresenterProtocol? { get set }
}

// MARK: - PresenterToInteractorProtocol
final class AppSettingsRouter: AppSettingsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: AppSettingsRouterToPresenterProtocol?
}
