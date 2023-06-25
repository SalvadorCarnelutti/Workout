//
//  
//  SessionsInteractor.swift
//  Workout
//
//  Created by Salvador on 6/21/23.
//
//
import CoreData

protocol SessionsPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var workout: Workout { get set }
    var managedObjectContext: NSManagedObjectContext { get }
    var workoutName: String { get }
    func addCompletionAction(formOutput: SessionFormOutput)
    func editCompletionAction(for exercise: Session, formOutput: SessionFormOutput)
}

// MARK: - PresenterToInteractorProtocol
final class SessionsInteractor: SessionsPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    var workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    var managedObjectContext: NSManagedObjectContext {
        workout.managedObjectContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    var workoutName: String {
        workout.name ?? ""
    }
    
    func addCompletionAction(formOutput: SessionFormOutput) {
        let session = Session(context: managedObjectContext)
        session.setup(with: formOutput, for: workout)
    }
    
    func editCompletionAction(for session: Session, formOutput: SessionFormOutput) {
        session.update(with: formOutput)
    }
}
