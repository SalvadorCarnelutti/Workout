//
//  
//  ScheduledSessionsInteractor.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//
//
import CoreData

protocol ScheduledSessionsPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var managedObjectContext: NSManagedObjectContext { get }
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput)
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionsInteractor: ScheduledSessionsPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func editCompletionAction(for session: Session, formOutput: SessionFormOutput) {
        session.update(with: formOutput)
    }
}
