//
//  
//  AddWorkoutInteractor.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import CoreData

protocol AddWorkoutPresenterToInteractorProtocol: AnyObject {
    var presenter: BaseViewProtocol? { get set }
    var managedObjectContext: NSManagedObjectContext { get }
    var workout: Workout { get set }
    func addCompletionAction(formOutput: FormOutput)
    func editCompletionAction(for exercise: Exercise, formOutput: FormOutput)
}

// MARK: - PresenterToInteractorProtocol
final class AddWorkoutInteractor: AddWorkoutPresenterToInteractorProtocol {
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
    
    func addCompletionAction(formOutput: FormOutput) {
        let exercise = Exercise(context: managedObjectContext)
        exercise.configure(with: formOutput)
        exercise.workout = workout
    }
    
    func editCompletionAction(for exercise: Exercise, formOutput: FormOutput) {
        exercise.configure(with: formOutput)
    }
}
