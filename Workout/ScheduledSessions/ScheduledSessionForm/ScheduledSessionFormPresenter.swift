//
//  
//  ScheduledSessionFormPresenter.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
//

import UIKit
import CoreData

protocol ScheduledSessionFormViewToPresenterProtocol: UIViewController {
    var exercisesCount: Int { get }
    var completionString: String { get }
    func viewLoaded()
    func exercise(at indexPath: IndexPath) -> Exercise
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func didDeleteRow(at indexPath: IndexPath)
}

protocol ScheduledSessionFormRouterToPresenterProtocol: UIViewController {
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput)
}

final class ScheduledSessionFormPresenter: BaseViewController {
    var viewScheduledSessionForm: ScheduledSessionFormPresenterToViewProtocol!
    var interactor: ScheduledSessionFormPresenterToInteractorProtocol!
    var router: ScheduledSessionFormPresenterToRouterProtocol!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Exercise> = {
        let predicate = NSPredicate(format: "workout == %@", self.interactor.workout)
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.predicate = predicate
        // TODO: Check later if necessary to see that ordering is preserved
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Exercise.order), ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: interactor.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
    }()
    
    override func loadView() {
        super.loadView()
        view = viewScheduledSessionForm
        viewScheduledSessionForm.loadView()
    }
    
    private func fetchExercises() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // TODO: Maybe a modal error meesage
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }
}


// MARK: - ViewToPresenterProtocol
extension ScheduledSessionFormPresenter: ScheduledSessionFormViewToPresenterProtocol {
    var completionString: String { "Edit" }
    
    
    var exercisesCount: Int { fetchedResultsController.fetchedObjects?.count ?? 0 }
    
    func viewLoaded() {
        fetchedResultsController.delegate = viewScheduledSessionForm
        fetchExercises()
    }
    
    func exercise(at indexPath: IndexPath) -> Exercise { fetchedResultsController.object(at: indexPath) }
    
    func deleteRow(at indexPath: IndexPath) {
        let exercise = exercise(at: indexPath)
        exercise.managedObjectContext?.delete(exercise)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        router.presentEditExerciseForm(for: exercise(at: indexPath))
    }
    
    func didDeleteRow(at indexPath: IndexPath) {
        Array(0..<indexPath.row).map { exercise(at: IndexPath(row: $0, section: 0)) }.forEach { $0.order -= 1 }
    }
}

// MARK: - RouterToPresenterProtocol
extension ScheduledSessionFormPresenter: ScheduledSessionFormRouterToPresenterProtocol {
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput) {
        interactor.editCompletionAction(for: exercise, formOutput: formOutput)
    }

}
