//
//  
//  ExercisesPresenter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//

import UIKit
import CoreData
import SwiftUI

protocol ExercisesViewToPresenterProtocol: AnyObject {
    var view: ExercisesPresenterToViewProtocol! { get set }
    var workoutName: String { get }
    var exercisesCount: Int { get }
    func viewLoaded()
    func addExerciseTapped()
    func exercise(at indexPath: IndexPath) -> Exercise
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func didDeleteRow(at indexPath: IndexPath)
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

protocol ExercisesRouterToPresenterProtocol: AnyObject {
    func addCompletionAction(formOutput: ExerciseFormOutput)
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput)
}

protocol ExercisesInteractorToPresenterProtocol: AnyObject {
    var exercisesCount: Int { get }
}

typealias ExercisesPresenterProtocol = ExercisesViewToPresenterProtocol & ExercisesRouterToPresenterProtocol & ExercisesInteractorToPresenterProtocol

final class ExercisesPresenter: EntityFetcher, ExercisesPresenterProtocol {
    weak var view: ExercisesPresenterToViewProtocol!
    let interactor: ExercisesPresenterToInteractorProtocol
    let router: ExercisesPresenterToRouterProtocol
    
    lazy var fetchedResultsController: NSFetchedResultsController<Exercise> = {
        let predicate = NSPredicate(format: "workout == %@", self.interactor.workout)
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Exercise.order, ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: interactor.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
    }()
    
    init(interactor: ExercisesPresenterToInteractorProtocol, router: ExercisesPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        interactor.presenter = self
        router.presenter = self
    }
}

// MARK: - ViewToPresenterProtocol
extension ExercisesPresenter {
    var workoutName: String { interactor.workoutName }
    var exercisesCount: Int { entitiesCount }
    
    func viewLoaded() {
        setFetchedResultsControllerDelegate(view)
        fetchEntities()
    }
    
    func addExerciseTapped() {
        router.presentAddExerciseForm()
    }
    
    func exercise(at indexPath: IndexPath) -> Exercise { entity(at: indexPath) }
    
    func deleteRow(at indexPath: IndexPath) {
        deleteEntity(at: indexPath)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        router.presentEditExerciseForm(for: exercise(at: indexPath))
    }
    
    func didDeleteRow(at indexPath: IndexPath) {
        Array(0..<indexPath.row).map { exercise(at: IndexPath(row: $0, section: 0)) }.forEach { $0.order -= 1 }
    }
    
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var exercises = fetchedEntities
        
        let fromOffsets = IndexSet(integer: sourceIndexPath.row)
        var toOffset = destinationIndexPath.row
        if sourceIndexPath.row < destinationIndexPath.row { toOffset += 1 }
        
        exercises.move(fromOffsets: fromOffsets, toOffset: toOffset)
        
        for (i, exercise) in exercises.enumerated() {
            exercise.order = Int16(exercises.count - i) - 1
        }
    }
}

// MARK: - InteractorToPresenterProtocol
extension ExercisesPresenter {}

// MARK: - RouterToPresenterProtocol
extension ExercisesPresenter {
    func addCompletionAction(formOutput: ExerciseFormOutput) {
        interactor.addCompletionAction(formOutput: formOutput)
    }
    
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput) {
        interactor.editCompletionAction(for: exercise, formOutput: formOutput)
    }
}
