//
//  
//  WorkoutSettingsConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//
//
import Foundation

final class WorkoutSettingsConfigurator {
    static func resolveEdit(for workout: Workout) -> WorkoutSettingsViewController {
        let interactor = WorkoutSettingsInteractor(workout: workout)
        let router = WorkoutSettingsRouter()
        
        let presenter = WorkoutSettingsPresenter(interactor: interactor, router: router)
        
        let view = WorkoutSettingsViewController(presenter: presenter)
        router.navigation = { view.navigationController }
        router.presentation = { view }

        return view
    }
}
