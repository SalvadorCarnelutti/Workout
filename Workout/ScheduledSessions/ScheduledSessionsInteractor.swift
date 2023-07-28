//
//  
//  ScheduledSessionsInteractor.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//
//
import CoreData
import OSLog

protocol ScheduledSessionsPresenterToInteractorProtocol: AnyObject {
    var managedObjectContext: NSManagedObjectContext { get }
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput)
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionsInteractor: ScheduledSessionsPresenterToInteractorProtocol {
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func editCompletionAction(for session: Session, formOutput: SessionFormOutput) {
        Logger.coreData.info("Editing session \(session) in current managed object context")
        session.update(with: formOutput)
    }
}
