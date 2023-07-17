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
import SwiftUI

protocol ScheduledSessionFormViewToPresenterProtocol: UIViewController {
    var exercisesCount: Int { get }
    var completionString: String { get }
    func viewLoaded()
    func exercise(at indexPath: IndexPath) -> Exercise
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func didDeleteRow(at indexPath: IndexPath)
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func didChangeExerciseCount()
}

protocol ScheduledSessionFormRouterToPresenterProtocol: UIViewController {
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput)
}

final class ScheduledSessionFormPresenter: BaseViewController, EntityFetcher {
    var viewScheduledSessionForm: ScheduledSessionFormPresenterToViewProtocol!
    var interactor: ScheduledSessionFormPresenterToInteractorProtocol!
    var router: ScheduledSessionFormPresenterToRouterProtocol!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let sessionFormOutput = viewScheduledSessionForm.sessionFormOutput else { return }
        interactor.editSessionCompletionAction(for: sessionFormOutput)
    }
    
    override func loadView() {
        super.loadView()
        view = viewScheduledSessionForm
        setupNavigationBar()
        viewScheduledSessionForm.loadView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = interactor.workoutName
    }
}

// MARK: - ViewToPresenterProtocol
extension ScheduledSessionFormPresenter: ScheduledSessionFormViewToPresenterProtocol {
    var completionString: String { "Edit" }
    
    var exercisesCount: Int { fetchedResultsController.fetchedObjects?.count ?? 0 }
    
    func viewLoaded() {
        viewScheduledSessionForm.fillSessionFields(with: interactor.formInput)
        setFetchedResultsControllerDelegate(viewScheduledSessionForm.fetchedResultsControllerDelegate)
        fetchEntities()
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
    
    func didChangeExerciseCount() {
        if isEmpty {
            interactor.emptySessions()
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - RouterToPresenterProtocol
extension ScheduledSessionFormPresenter: ScheduledSessionFormRouterToPresenterProtocol {
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput) {
        interactor.editExerciseCompletionAction(for: exercise, formOutput: formOutput)
    }
}
