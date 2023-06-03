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
    var persistentContainer: NSPersistentContainer { get set }
    func loadPersistentContainer()
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsInteractor: WorkoutsPresenterToInteractorProtocol {
    weak var presenter: WorkoutsInteractorToPresenterProtocol?
    var persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func loadPersistentContainer() {
        persistentContainer.loadPersistentStores { [presenter] (persistentStoreDescription, error) in
            if let error = error {
                presenter?.onPersistentContainerLoadFailure(error: error)
            } else {
                print(self.persistentContainer.viewContext)
                presenter?.onPersistentContainerLoadSuccess()
            }
        }
    }
}
