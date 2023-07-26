//
//  
//  ExercisesConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import CoreData

final class ExercisesConfigurator {
    static func resolveEdit(for workout: Workout) -> ExercisesViewController {
        let interactor = ExercisesInteractor(workout: workout)
        let router = ExercisesRouter()
        
        let presenter = ExercisesPresenter(interactor: interactor, router: router)
        
        let view = ExercisesViewController(presenter: presenter)
        router.navigation = { view.navigationController }

        return view
    }
}
