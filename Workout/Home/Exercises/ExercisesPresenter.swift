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

protocol ExercisesViewToPresenterProtocol: UIViewController {
    var exercisesCount: Int { get }
    func viewLoaded()
    func exercise(at indexPath: IndexPath) -> Exercise
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func didDeleteRow(at indexPath: IndexPath)
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func didChangeExerciseCount()
}

protocol ExercisesRouterToPresenterProtocol: UIViewController {
    func addCompletionAction(formOutput: ExerciseFormOutput)
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput)
}

protocol ExercisesInteractorToPresenterProtocol: BaseViewProtocol {
    var exercisesCount: Int { get }
}

final class ExercisesPresenter: BaseViewController, EntityFetcher {
    var viewExercises: ExercisesPresenterToViewProtocol!
    var interactor: ExercisesPresenterToInteractorProtocol!
    var router: ExercisesPresenterToRouterProtocol!
    
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
    
    override func loadView() {
        super.loadView()
        view = viewExercises
        viewExercises.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = interactor.workoutName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            image: UIImage.add,
                                                            target: self,
                                                            action: #selector(addExerciseTapped))
    }
    
    @objc private func addExerciseTapped() {
        router.presentAddExerciseForm()
    }
    
    private func showEmptyState() {
        configureEmptyContentUnavailableConfiguration(image: .ellipsis,
                                                      text: "No exercises at the moment",
                                                      secondaryText: "Start adding on the top-right")
    }
    
    private func updateContentUnavailableConfiguration() {
        UIView.animate(withDuration: 0.25, animations: {
            self.isEmpty ? self.showEmptyState() : self.clearContentUnavailableConfiguration()
        })
    }
}

// MARK: - ViewToPresenterProtocol
extension ExercisesPresenter: ExercisesViewToPresenterProtocol {
    var exercisesCount: Int { entitiesCount }
    
    func viewLoaded() {
        setFetchedResultsControllerDelegate(viewExercises.fetchedResultsControllerDelegate)
        fetchEntities()
        updateContentUnavailableConfiguration()
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
        // TODO: Remove prints
        var exercises = fetchedEntities
//        print(exercises.map { "Start: \($0.name!): \($0.order) \n" })
//        print("From: \(sourceIndexPath.row) to \(destinationIndexPath.row)")
        
        let fromOffsets = IndexSet(integer: sourceIndexPath.row)
        var toOffset = destinationIndexPath.row
        if sourceIndexPath.row < destinationIndexPath.row { toOffset += 1 }
        
        exercises.move(fromOffsets: fromOffsets, toOffset: toOffset)
        
//        print(exercises.map { "Before: \($0.name!): \($0.order) \n" })
        for (i, exercise) in exercises.enumerated() {
            exercise.order = Int16(exercises.count - i) - 1
        }
        
//        print(exercises.map { "End: \($0.name!): \($0.order) \n" })
    }
    
    func didChangeExerciseCount() {
        updateContentUnavailableConfiguration()
    }
}

// MARK: - InteractorToPresenterProtocol
extension ExercisesPresenter: ExercisesInteractorToPresenterProtocol {}

// MARK: - RouterToPresenterProtocol
extension ExercisesPresenter: ExercisesRouterToPresenterProtocol {
    func addCompletionAction(formOutput: ExerciseFormOutput) {
        interactor.addCompletionAction(formOutput: formOutput)
    }
    
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput) {
        interactor.editCompletionAction(for: exercise, formOutput: formOutput)
    }
}
