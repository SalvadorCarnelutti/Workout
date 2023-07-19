//
//  CoreDataManager.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import CoreData
import UIKit
import OSLog

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer = NSPersistentContainer(name: "Workout")
        
    private init() {}
    
    func loadPersistentContainer(onCompletion completionHandler: @escaping (Result<NSPersistentStoreDescription, Error>) -> ()) {
        persistentContainer.loadPersistentStores { [weak self] (persistentStoreDescription, error) in
            guard let self = self else { return }
            
            if let error = error {
                completionHandler(.failure(error))
                Logger.coreData.error("Persistent container failed to load. Error \(error)")
            } else {
                self.setupNotificationHandling()
                completionHandler(.success(persistentStoreDescription))
                Logger.coreData.info("Persistent container loaded succesfully")
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
        Logger.coreData.info("Added notificationCenter observer for willTerminateNotification")
        
        notificationCenter.addObserver(self,
                                       selector: #selector(saveContext),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
        Logger.coreData.info("Added notificationCenter observer for didEnterBackgroundNotification")
    }
    
    @objc func saveContext() {
        let viewContext = persistentContainer.viewContext
        if viewContext.hasChanges {
            Logger.coreData.info("Managed object context has registered changes")
            do {
                try viewContext.save()
                Logger.coreData.info("Managed object context saved changes successfully")
            } catch {
                // TODO: Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                Logger.coreData.warning("Unresolved error \(nserror), \(nserror.userInfo) while saving the manged object context")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
