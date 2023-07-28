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

protocol ScheduledSessionFormViewToPresenterProtocol: AnyObject {
    var view: ScheduledSessionFormPresenterToViewProtocol! { get set }
    var workoutName: String { get }
    var exercisesCount: Int { get }
    var completionString: String { get }
    func viewLoaded()
    func exercise(at indexPath: IndexPath) -> Exercise
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func didDeleteRow(at indexPath: IndexPath)
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func editSessionCompletionAction(for sessionFormOutput: SessionFormOutput)
}

protocol ScheduledSessionFormRouterToPresenterProtocol: AnyObject {
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput)
}

typealias ScheduledSessionFormPresenterProtocol = ScheduledSessionFormViewToPresenterProtocol & ScheduledSessionFormRouterToPresenterProtocol

final class ScheduledSessionFormPresenter: ScheduledSessionFormPresenterProtocol, EntityFetcher {
    weak var view: ScheduledSessionFormPresenterToViewProtocol!
    let interactor: ScheduledSessionFormPresenterToInteractorProtocol
    let router: ScheduledSessionFormPresenterToRouterProtocol
    
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
    
    init(interactor: ScheduledSessionFormPresenterToInteractorProtocol, router: ScheduledSessionFormPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        router.presenter = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        guard let sessionFormOutput = viewScheduledSessionForm.sessionFormOutput else { return }
//        interactor.editSessionCompletionAction(for: sessionFormOutput)
//    }
}

// MARK: - ViewToPresenterProtocol
extension ScheduledSessionFormPresenter {
    var workoutName: String { interactor.workoutName }
    
    var completionString: String { String(localized: "Edit") }
    
    var exercisesCount: Int { fetchedResultsController.fetchedObjects?.count ?? 0 }
    
    func viewLoaded() {
        view.fillSessionFields(with: interactor.formInput)
        setFetchedResultsControllerDelegate(view.fetchedResultsControllerDelegate)
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
        didChangeExerciseCount()
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
            router.popViewController()
        }
    }
    
    func editSessionCompletionAction(for sessionFormOutput: SessionFormOutput) {
        interactor.editSessionCompletionAction(for: sessionFormOutput)
    }
}

// MARK: - RouterToPresenterProtocol
extension ScheduledSessionFormPresenter {
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput) {
        interactor.editExerciseCompletionAction(for: exercise, formOutput: formOutput)
    }
}
