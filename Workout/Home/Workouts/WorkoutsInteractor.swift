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
    func addCompletionAction(name: String)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutsInteractor: WorkoutsPresenterToInteractorProtocol {
    weak var presenter: WorkoutsInteractorToPresenterProtocol?
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func addCompletionAction(name: String) {
        let workout = Workout(context: managedObjectContext)
        workout.setup(with: name)
    }
}
