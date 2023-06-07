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
    var exercisesCount: Int { get }
    func exerciseAt(_ index: Int) -> Exercise
    func deleteExerciseAt(_ index: Int)
    func moveExerciseAt(from: Int, to: Int)
}

// MARK: - PresenterToInteractorProtocol
final class AddWorkoutInteractor: AddWorkoutPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    private let workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    init(managedObjectContext: NSManagedObjectContext) {
        workout = Workout(context: managedObjectContext)
    }
    
    private var exercises = [Exercise]()
        
    // TODO: Save
//        do {
//            try persistentContainer.viewContext.save()
//        } catch {
//            print("\(error), \(error.localizedDescription)")
//        }
    
    var exercisesCount: Int {
        exercises.count
    }
    
    func exerciseAt(_ index: Int) -> Exercise {
        exercises[index]
    }
    
    func deleteExerciseAt(_ index: Int) {
        exercises.remove(at: index)
    }
    
    func moveExerciseAt(from: Int, to: Int) {
        let exercise = exercises.remove(at: from)
        exercises.insert(exercise, at: to)
    }
}
