//
//  
//  ExercisesInteractor.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import CoreData
import OSLog

protocol ExercisesPresenterToInteractorProtocol: AnyObject {
    var presenter: ExercisesInteractorToPresenterProtocol! { get set }
    var workout: Workout { get }
    var managedObjectContext: NSManagedObjectContext { get }
    var workoutName: String { get }
    func addCompletionAction(formOutput: ExerciseFormOutput)
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput)
}

// MARK: - PresenterToInteractorProtocol
final class ExercisesInteractor: ExercisesPresenterToInteractorProtocol {
    weak var presenter: ExercisesInteractorToPresenterProtocol!
    let workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    init(managedObjectContext: NSManagedObjectContext) {
        workout = Workout(context: managedObjectContext)
    }
    
    var managedObjectContext: NSManagedObjectContext { workout.managedObjectContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) }
    
    var workoutName: String {
        workout.name ?? ""
    }
    
    func addCompletionAction(formOutput: ExerciseFormOutput) {
        let exercise = Exercise(context: managedObjectContext)
        let exerciseOrder = presenter.exercisesCount
        Logger.coreData.info("Adding new exercise to managed object context")
        exercise.setup(with: formOutput, order: exerciseOrder, for: workout)
    }
    
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput) {
        Logger.coreData.info("Editing exercise \(exercise) in current managed object context")
        exercise.update(with: formOutput)
    }
}
