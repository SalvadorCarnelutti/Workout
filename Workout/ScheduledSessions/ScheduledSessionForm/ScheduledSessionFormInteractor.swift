//
//  
//  ScheduledSessionFormInteractor.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
//

import CoreData
import OSLog

struct ScheduledSessionFormModel {
    let session: Session
    let formInput: SessionFormInput
}

protocol ScheduledSessionFormPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var formInput: SessionFormInput { get }
    var managedObjectContext: NSManagedObjectContext { get }
    var workout: Workout { get }
    var workoutName: String { get }
    func editSessionCompletionAction(for sessionFormOutput: SessionFormOutput)
    func editExerciseCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput)
    func emptySessions()
}

// MARK: - PresenterToInteractorProtocol
final class ScheduledSessionFormInteractor: ScheduledSessionFormPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    private let formModel: ScheduledSessionFormModel

    init(formModel: ScheduledSessionFormModel) {
        self.formModel = formModel
    }
    
    var formInput: SessionFormInput {
        formModel.formInput
    }
    
    var managedObjectContext: NSManagedObjectContext {
        formModel.session.managedObjectContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    var workout: Workout {
        formModel.session.workout!
    }
    
    var workoutName: String {
        workout.name ?? ""
    }
    
    func editSessionCompletionAction(for sessionFormOutput: SessionFormOutput) {
        formModel.session.update(with: sessionFormOutput)
    }
    
    func editExerciseCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput) {
        Logger.coreData.info("Editing exercise \(exercise) in current managed object context")
        exercise.update(with: formOutput)
    }
    
    func emptySessions() {
        workout.emptySessions()
    }
}
