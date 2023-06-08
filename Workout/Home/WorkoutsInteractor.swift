//
//  
//  WorkoutsInteractor.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//
//
import Foundation
import CoreData

protocol WorkoutsPresenterToInteractorProtocol: AnyObject {
    var presenter: WorkoutsInteractorToPresenterProtocol? { get set }
    var managedObjectContext: NSManagedObjectContext { get }
    func loadPersistentContainer()
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsInteractor: WorkoutsPresenterToInteractorProtocol {
    weak var presenter: WorkoutsInteractorToPresenterProtocol?
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func loadPersistentContainer() {
        persistentContainer.loadPersistentStores { [weak self] (persistentStoreDescription, error) in
            guard let self = self else { return }
            if let error = error {
                self.presenter?.onPersistentContainerLoadFailure(error: error)
            } else {
                print(self.persistentContainer.viewContext)
                self.presenter?.onPersistentContainerLoadSuccess()
            }
        }
    }
}
