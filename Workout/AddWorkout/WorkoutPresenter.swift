//
//  
//  WorkoutPresenter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//

import UIKit
import CoreData

protocol WorkoutViewToPresenterProtocol: UIViewController {
    var exercisesCount: Int { get }
    func viewLoaded()
    func exerciseAt(indexPath: IndexPath) -> Exercise
    func didSelectRowAt(_ indexPath: IndexPath)
}

protocol WorkoutRouterToPresenterProtocol: UIViewController {
    func addCompletionAction(formOutput: FormOutput)
    func editCompletionAction(for exercise: Exercise, formOutput: FormOutput)
}

final class WorkoutPresenter: BaseViewController {
    var viewAddWorkout: WorkoutPresenterToViewProtocol!
    var interactor: WorkoutPresenterToInteractorProtocol!
    var router: WorkoutPresenterToRouterProtocol!
    
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
        view = viewAddWorkout
        viewAddWorkout.loadView()
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
extension WorkoutPresenter: WorkoutViewToPresenterProtocol {
    var exercisesCount: Int { fetchedResultsController.fetchedObjects?.count ?? 0 }
    
    func viewLoaded() {
        fetchedResultsController.delegate = viewAddWorkout
        fetchExercises()
    }
    
    func exerciseAt(indexPath: IndexPath) -> Exercise {
        fetchedResultsController.object(at: indexPath)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        router.presentEditExerciseForm(for: fetchedResultsController.object(at: indexPath))
    }
}

extension WorkoutPresenter: WorkoutRouterToPresenterProtocol {
    func addCompletionAction(formOutput: FormOutput) {
        interactor.addCompletionAction(formOutput: formOutput)
    }
    
    func editCompletionAction(for exercise: Exercise, formOutput: FormOutput) {
        interactor.editCompletionAction(for: exercise, formOutput: formOutput)
    }
}
