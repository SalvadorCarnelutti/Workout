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

protocol EntityFetcher: BaseViewController {
    associatedtype Entity: NSManagedObject
    
    var fetchedResultsController: NSFetchedResultsController<Entity> { get set }
}

extension EntityFetcher {
    var entitiesCount: Int { fetchedResultsController.fetchedObjects?.count ?? 0 }
    var fetchedEntities: [Entity] { fetchedResultsController.fetchedObjects ?? [] }
    func setFetchRequestPredicate(_ predicate: NSPredicate) { fetchedResultsController.fetchRequest.predicate = predicate }
    func setFetchedResultsControllerDelegate(_ delegate: NSFetchedResultsControllerDelegate) { fetchedResultsController.delegate = delegate }
    func entity(at indexPath: IndexPath) -> Entity { fetchedResultsController.object(at: indexPath) }
    
    func deleteEntity(at indexPath: IndexPath) {
        let entity = entity(at: indexPath)
        entity.managedObjectContext?.delete(entity)
    }
    
    func fetchEntities() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            presentOKAlert(title: "Unexpected error occured", message: "There was an error loading your information")
        }
    }
}

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

final class WorkoutsPresenter: BaseViewController, EntityFetcher {
    var viewWorkout: WorkoutsPresenterToViewProtocol!
    var interactor: WorkoutsPresenterToInteractorProtocol!
    var router: WorkoutsPresenterToRouterProtocol!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Workout> = {
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
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
}

// MARK: - ViewToPresenterProtocol
extension WorkoutsPresenter: WorkoutsViewToPresenterProtocol {
    var workoutsCount: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func viewLoaded() {
        setFetchedResultsControllerDelegate(viewWorkout)
        fetchEntities()
    }
    
    func workout(at indexPath: IndexPath) -> Workout {
        entity(at: indexPath)
    }
    
    func deleteRow(at indexPath: IndexPath) {
        deleteEntity(at: indexPath)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let workout = workout(at: indexPath)
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
