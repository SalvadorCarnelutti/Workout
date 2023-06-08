//
//  
//  WorkoutInteractor.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import CoreData

protocol WorkoutPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var workout: Workout { get set }
    var managedObjectContext: NSManagedObjectContext { get }
    var workoutName: String { get }
    func addCompletionAction(formOutput: FormOutput)
    func editCompletionAction(for exercise: Exercise, formOutput: FormOutput)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutInteractor: WorkoutPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    var workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    init(managedObjectContext: NSManagedObjectContext) {
        workout = Workout(context: managedObjectContext)
    }
    
    var managedObjectContext: NSManagedObjectContext {
        workout.managedObjectContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    var workoutName: String {
        workout.name ?? ""
    }
    
    func addCompletionAction(formOutput: FormOutput) {
        let exercise = Exercise(context: managedObjectContext)
        exercise.configure(with: formOutput)
        exercise.workout = workout
    }
    
    func editCompletionAction(for exercise: Exercise, formOutput: FormOutput) {
        exercise.configure(with: formOutput)
    }
}
