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
    var exercisesCount: Int { get }
    func exerciseAt(_ index: Int) -> Exercise
    func deleteExerciseAt(_ index: Int)
    func moveExerciseAt(from: Int, to: Int)
}

// MARK: - PresenterToInteractorProtocol
final class AddWorkoutInteractor: AddWorkoutPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    private let persistentContainer: NSPersistentContainer
    
    private var exercises = [Exercise]()
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        
        let ex = Exercise(context: managedObjectContext)
        ex.name = "Dumbbell curls"
        ex.duration = 20
        ex.sets = 4
        
        for i in 0..<10 {
            let ex = Exercise(context: managedObjectContext)
            ex.name = "Dumbbell curls"
            ex.duration = 20
            ex.sets = 4
            ex.reps = Int16(i)
            exercises.append(ex)
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
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
