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

protocol WorkoutsViewToPresenterProtocol: AnyObject {
    var view: WorkoutsPresenterToViewProtocol! { get set }
    var workoutsCount: Int { get }
    func viewLoaded()
    func addWorkoutTapped()
    func workout(at indexPath: IndexPath) -> Workout
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func handleNotificationTap(for identifier: String)
}

protocol WorkoutsInteractorToPresenterProtocol: AnyObject {
    func workoutCreated(_ workout: Workout)
}

protocol WorkoutsRouterToPresenterProtocol: AnyObject {
    func addCompletionAction(name: String)
}

typealias WorkoutsPresenterProtocol = WorkoutsViewToPresenterProtocol & WorkoutsInteractorToPresenterProtocol & WorkoutsRouterToPresenterProtocol

final class WorkoutsPresenter: EntityFetcher, WorkoutsPresenterProtocol {
    weak var view: WorkoutsPresenterToViewProtocol!
    let interactor: WorkoutsPresenterToInteractorProtocol
    let router: WorkoutsPresenterToRouterProtocol
    
    init(interactor: WorkoutsPresenterToInteractorProtocol, router: WorkoutsPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        interactor.presenter = self
        router.presenter = self
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Workout> = {
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Workout.name, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: interactor.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
    }()
    
    func handleNotificationTap(for identifier: String) {
        guard let scheduledWorkout = fetchedEntities.first(where: { $0.compactMappedSessions.contains { $0.uuidString == identifier } }) else { return }
        
        router.handleNotificationTap(for: scheduledWorkout)
    }
    
    func addWorkoutTapped() {
        router.pushAddWorkout()
    }
}

// MARK: - ViewToPresenterProtocol
extension WorkoutsPresenter {
    var workoutsCount: Int { fetchedResultsController.fetchedObjects?.count ?? 0 }
    
    func viewLoaded() {
        setFetchedResultsControllerDelegate(view)
        fetchEntities()
    }
    
    func workout(at indexPath: IndexPath) -> Workout { entity(at: indexPath) }
    
    func deleteRow(at indexPath: IndexPath) {
        deleteEntity(at: indexPath)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let workout = workout(at: indexPath)
        router.pushEditWorkout(for: workout)
    }
}

// MARK: - InteractorToPresenterProtocol
extension WorkoutsPresenter {
    func workoutCreated(_ workout: Workout) {
        router.pushEditWorkout(for: workout)
    }
}

// MARK: - RouterToPresenterProtocol
extension WorkoutsPresenter {
    func addCompletionAction(name: String) {
        interactor.addCompletionAction(name: name)
    }
}
