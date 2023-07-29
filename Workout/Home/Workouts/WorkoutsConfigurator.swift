//
//  
//  WorkoutsConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//
//
import CoreData

final class WorkoutsConfigurator {    
    static func resolveFor(managedObjectContext: NSManagedObjectContext) -> WorkoutsViewController {
        let interactor = WorkoutsInteractor(managedObjectContext: managedObjectContext)
        let router = WorkoutsRouter()
        
        let presenter = WorkoutsPresenter(interactor: interactor, router: router)
        
        let view = WorkoutsViewController(presenter: presenter)
        router.navigation = { view }

        return view
    }
}
