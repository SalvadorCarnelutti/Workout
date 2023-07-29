//
//  
//  SessionsConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/21/23.
//
//
import Foundation

final class SessionsConfigurator {
    static func resolve(for workout: Workout) -> SessionsViewController {
        let interactor = SessionsInteractor(workout: workout)
        let router = SessionsRouter()
        
        let presenter = SessionsPresenter(interactor: interactor, router: router)
        
        let view = SessionsViewController(presenter: presenter)
        router.navigation = { view }

        return view
    }
}
