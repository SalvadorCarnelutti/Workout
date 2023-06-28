//
//  CoreDataManager.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Workout")
        
        // TODO: Check why, when set memory is not persisting, also the loader is never being shown while fetching data
//        let description = NSPersistentStoreDescription()
//        description.shouldMigrateStoreAutomatically = true
//        description.shouldInferMappingModelAutomatically = true
//
//        persistentContainer.persistentStoreDescriptions = [description]
        
        return persistentContainer
    }()
        
    private init() {}
    
    func loadPersistentContainer(onCompletion completionHandler: @escaping (Result<NSPersistentStoreDescription, Error>) -> ()) {
        persistentContainer.loadPersistentStores { [weak self] (persistentStoreDescription, error) in
            guard let self = self else { return }
            
            if let error = error {
                completionHandler(.failure(error))
            } else {
                self.setupNotificationHandling()
                completionHandler(.success(persistentStoreDescription))
            }
        }
    }
    
    var managedObjectContext: NSManagedObjectContext { persistentContainer.viewContext }

    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveContext),
                                       name: UIApplication.willTerminateNotification,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(saveContext),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    @objc func saveContext() {
        let viewContext = persistentContainer.viewContext
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                // TODO: Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
