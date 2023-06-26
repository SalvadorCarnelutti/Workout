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

protocol ExercisesViewToPresenterProtocol: UIViewController {
    var exercisesCount: Int { get }
    func viewLoaded()
    func exercise(at indexPath: IndexPath) -> Exercise
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func didDeleteRow(at indexPath: IndexPath)
}

protocol ExercisesRouterToPresenterProtocol: UIViewController {
    func addCompletionAction(formOutput: ExerciseFormOutput)
    func editCompletionAction(for exercise: Exercise, formOutput: ExerciseFormOutput)
}

protocol ExercisesInteractorToPresenterProtocol: BaseViewProtocol {
    var exercisesCount: Int { get }
}

final class ExercisesPresenter: BaseViewController {
    var viewExercises: ExercisesPresenterToViewProtocol!
    var interactor: ExercisesPresenterToInteractorProtocol!
    var router: ExercisesPresenterToRouterProtocol!
    
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
extension ExercisesPresenter: ExercisesViewToPresenterProtocol {
    var exercisesCount: Int { fetchedResultsController.fetchedObjects?.count ?? 0 }
    
    func viewLoaded() {
        fetchedResultsController.delegate = viewExercises
        fetchExercises()
    }
    
    func exercise(at indexPath: IndexPath) -> Exercise { fetchedResultsController.object(at: indexPath) }
    
    func deleteRow(at indexPath: IndexPath) {
        let exercise = exercise(at: indexPath)
        exercise.managedObjectContext?.delete(exercise)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        router.presentEditExerciseForm(for: fetchedResultsController.object(at: indexPath))
    }
    
    func didDeleteRow(at indexPath: IndexPath) {
        Array(0..<indexPath.row).map { exercise(at: IndexPath(row: $0, section: 0)) }.forEach { $0.order -= 1 }
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
