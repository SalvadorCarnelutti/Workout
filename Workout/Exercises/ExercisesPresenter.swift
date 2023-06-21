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
    func exerciseAt(indexPath: IndexPath) -> Exercise
    func deleteRowAt(indexPath: IndexPath)
    func didSelectRowAt(_ indexPath: IndexPath)
    func didDeleteRowAt(_ indexPath: IndexPath)
}

protocol ExercisesRouterToPresenterProtocol: UIViewController {
    func addCompletionAction(formOutput: FormOutput)
    func editCompletionAction(for exercise: Exercise, formOutput: FormOutput)
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
    
    func exerciseAt(indexPath: IndexPath) -> Exercise { fetchedResultsController.object(at: indexPath) }
    
    func deleteRowAt(indexPath: IndexPath) {
        let exercise = exerciseAt(indexPath: indexPath)
        exercise.managedObjectContext?.delete(exercise)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        router.presentEditExerciseForm(for: fetchedResultsController.object(at: indexPath))
    }
    
    func didDeleteRowAt(_ indexPath: IndexPath) {
        Array(0..<indexPath.row).map { exerciseAt(indexPath: IndexPath(row: $0, section: 0)) }.forEach { $0.order -= 1 }
    }
}

// MARK: - InteractorToPresenterProtocol
extension ExercisesPresenter: ExercisesInteractorToPresenterProtocol {}

// MARK: - RouterToPresenterProtocol
extension ExercisesPresenter: ExercisesRouterToPresenterProtocol {
    func addCompletionAction(formOutput: FormOutput) {
        interactor.addCompletionAction(formOutput: formOutput)
    }
    
    func editCompletionAction(for exercise: Exercise, formOutput: FormOutput) {
        interactor.editCompletionAction(for: exercise, formOutput: formOutput)
    }
}
