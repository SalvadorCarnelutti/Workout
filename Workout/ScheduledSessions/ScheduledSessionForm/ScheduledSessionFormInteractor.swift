//
//  
//  ScheduledSessionFormInteractor.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
//
import CoreData

protocol ScheduledSessionFormPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var managedObjectContext: NSManagedObjectContext { get }
    var workout: Workout { get }
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput)
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionFormInteractor: ScheduledSessionFormPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    private let session: Session

    init(session: Session) {
        self.session = session
    }
    
    var managedObjectContext: NSManagedObjectContext {
        session.managedObjectContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    var workout: Workout {
        session.workout!
    }
    
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput) {
        exercise.update(with: formOutput)
    }
}
