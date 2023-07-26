//
//  EntityFetcher.swift
//  Workout
//
//  Created by Salvador on 7/19/23.
//

import CoreData
import OSLog

protocol EntityFetcher: AnyObject {
    associatedtype Entity: NSManagedObject
    
    var fetchedResultsController: NSFetchedResultsController<Entity> { get set }
}

extension EntityFetcher {
    var entitiesCount: Int { fetchedResultsController.fetchedObjects?.count ?? 0 }
    var isEmpty: Bool { entitiesCount == 0 }
    var fetchedEntities: [Entity] { fetchedResultsController.fetchedObjects ?? [] }
    func setFetchRequestPredicate(_ predicate: NSPredicate) { fetchedResultsController.fetchRequest.predicate = predicate }
    func setFetchedResultsControllerDelegate(_ delegate: NSFetchedResultsControllerDelegate) { fetchedResultsController.delegate = delegate }
    func entity(at indexPath: IndexPath) -> Entity { fetchedResultsController.object(at: indexPath) }
    
    func deleteEntity(at indexPath: IndexPath) {
        let entity = entity(at: indexPath)
        Logger.coreData.info("Deleting \(String(describing: type(of: entity)).lowercased()) \(entity) from current managed object context")
        entity.managedObjectContext?.delete(entity)
        Logger.coreData.info("Deleted \(String(describing: type(of: entity)).lowercased()) from current managed object context")
    }
    
    func fetchEntities() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
//            presentErrorMessage()
        }
    }
}

//import CoreData
//
//class CustomFetchedResultsController<T: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {
//    private let fetchedResultsController: NSFetchedResultsController<T>
//    
//    init(fetchRequest: NSFetchRequest<T>, managedObjectContext: NSManagedObjectContext) {
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//        super.init()
//        fetchedResultsController.delegate = self
//        
//        // Perform initial fetch
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            // Handle fetch error
//            print("Error performing fetch: \(error.localizedDescription)")
//        }
//    }
//    
//    // Add additional methods or convenience functions here
//    
//    // MARK: - NSFetchedResultsControllerDelegate methods
//    
//    // Implement delegate methods here if needed
//}
