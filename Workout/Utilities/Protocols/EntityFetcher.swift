//
//  EntityFetcher.swift
//  Workout
//
//  Created by Salvador on 7/19/23.
//

import CoreData
import OSLog

protocol EntityFetcher: BaseViewController {
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
        Logger.coreData.info("Deleting \(entity.self) \(entity) from current managed object context")
        entity.managedObjectContext?.delete(entity)
    }
    
    func fetchEntities() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            presentErrorMessage()
        }
    }
}
