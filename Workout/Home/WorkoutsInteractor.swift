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
    
//    var workout: Workout {
//        let work = Workout(context: managedObjectContext)
//        // TODO: Actually make a Workout core data model object and from there check that Exercise behaviour works as expected (Saving will save the workout and its exercises to the database). And also that the exercise ordering works as expected
//        for i in 1..<10 {
//            let ex = Exercise(context: managedObjectContext)
//            ex.name = "Dumbbell curls"
//            ex.duration = 20
//            ex.sets = 4
//            ex.reps = Int16(i)
//            ex.workout = work
//        }
//
//        return work
//    }
}
