//
//  
//  ScheduledSessionsConfigurator.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//
//
import CoreData

final class ScheduledSessionsConfigurator {
    static func resolveFor(managedObjectContext: NSManagedObjectContext) -> ScheduledSessionsViewController {
        let interactor = ScheduledSessionsInteractor(managedObjectContext: managedObjectContext)
        let router = ScheduledSessionsRouter()
        
        let presenter = ScheduledSessionsPresenter(interactor: interactor, router: router)
        
        let view = ScheduledSessionsViewController(presenter: presenter)
        router.navigation = { view.navigationController }

        return view
    }
}
