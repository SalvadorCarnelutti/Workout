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
import OSLog

protocol WorkoutsPresenterToInteractorProtocol: AnyObject {
    var presenter: WorkoutsInteractorToPresenterProtocol! { get set }
    var managedObjectContext: NSManagedObjectContext { get }
    func addCompletionAction(name: String)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsInteractor: WorkoutsPresenterToInteractorProtocol {
    var presenter: WorkoutsInteractorToPresenterProtocol!
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func addCompletionAction(name: String) {
        let workout = Workout(context: managedObjectContext)
        Logger.coreData.info("Adding new workout to managed object context")
        workout.setup(with: name)
        
        presenter.workoutCreated(workout)
    }
}
