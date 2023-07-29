//
//  
//  AppSettingsConfigurator.swift
//  Workout
//
//  Created by Salvador on 7/7/23.
//
//
import CoreData

final class AppSettingsConfigurator {
    static func resolveFor(managedObjectContext: NSManagedObjectContext) -> AppSettingsViewController {
        let interactor = AppSettingsInteractor(managedObjectContext: managedObjectContext)
        let router = AppSettingsRouter()
        
        let presenter = AppSettingsPresenter(interactor: interactor, router: router)
        
        let view = AppSettingsViewController(presenter: presenter)

        return view
    }
}
