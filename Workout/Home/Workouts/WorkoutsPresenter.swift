//
//  
//  WorkoutsPresenter.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//
//

import UIKit
import CoreData

protocol WorkoutsViewToPresenterProtocol: UIViewController {
    var workoutsCount: Int { get }
    func viewLoaded()
    func workout(at indexPath: IndexPath) -> Workout
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
}

protocol WorkoutsInteractorToPresenterProtocol: BaseViewProtocol {
    func workoutCreated(_ workout: Workout)
}

protocol WorkoutsRouterToPresenterProtocol: UIViewController {
    func addCompletionAction(name: String)
}

final class WorkoutsPresenter: BaseViewController {
    var viewWorkout: WorkoutsPresenterToViewProtocol!
    var interactor: WorkoutsPresenterToInteractorProtocol!
    var router: WorkoutsPresenterToRouterProtocol!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Workout> = {
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        // TODO: Check later if necessary to see that ordering is preserved
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Workout.name, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: interactor.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
    }()
    
    override func loadView() {
        super.loadView()
        view = viewWorkout
        viewWorkout.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Workouts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            image: UIImage.add,
                                                            target: self,
                                                            action: #selector(addWorkoutTapped))
    }
    
    @objc private func addWorkoutTapped() {
        router.pushAddWorkout()
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
extension WorkoutsPresenter: WorkoutsViewToPresenterProtocol {
    var workoutsCount: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func viewLoaded() {
        fetchedResultsController.delegate = viewWorkout
        fetchExercises()
    }
    
    func workout(at indexPath: IndexPath) -> Workout {
        fetchedResultsController.object(at: indexPath)
    }
    
    func deleteRow(at indexPath: IndexPath) {
        let workout = workout(at: indexPath)
        workout.managedObjectContext?.delete(workout)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let workout = fetchedResultsController.object(at: indexPath)
        router.pushEditWorkout(for: workout)
    }
}

// MARK: - InteractorToPresenterProtocol
extension WorkoutsPresenter: WorkoutsInteractorToPresenterProtocol {
    func workoutCreated(_ workout: Workout) {
        router.pushEditWorkout(for: workout)
    }
}

// MARK: - RouterToPresenterProtocol
extension WorkoutsPresenter: WorkoutsRouterToPresenterProtocol {
    func addCompletionAction(name: String) {
        interactor.addCompletionAction(name: name)
    }
}
