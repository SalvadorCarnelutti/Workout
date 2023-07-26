//
//  XCTest.swift
//  WorkoutTests
//
//  Created by Salvador on 7/21/23.
//

import XCTest
import CoreData

extension XCTest {
    func setupCoreDataStack(with name: String, `in` bundle: Bundle) -> NSManagedObjectContext {
        // Fetch Model URL
        let modelURL = bundle.url(forResource: name, withExtension: "momd")!

        // Initialize Managed Object Model
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!

        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        // Add Persistent Store
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)

        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }
}
