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
    func didChangeWorkoutCount()
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
    
    func handleNotificationTap(for identifier: String) {
        guard let scheduledWorkout = fetchedEntities.first(where: { $0.compactMappedSessions.contains { $0.uuidString == identifier } }) else { return }
        
        router.handleNotificationTap(for: scheduledWorkout)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = String(localized: "Workouts")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            image: UIImage.add,
                                                            target: self,
                                                            action: #selector(addWorkoutTapped))
    }
    
    @objc private func addWorkoutTapped() {
        router.pushAddWorkout()
    }
    
    private func showEmptyState() {
        configureEmptyContentUnavailableConfiguration(image: .ellipsis,
                                                      text: String(localized: "No workouts at the moment"),
                                                      secondaryText: String(localized: "Start adding on the top-right"))
    }
    
    private func updateContentUnavailableConfiguration() {
        UIView.animate(withDuration: 0.25, animations: {
            self.isEmpty ? self.showEmptyState() : self.clearContentUnavailableConfiguration()
        })
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
        updateContentUnavailableConfiguration()
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
    
    func didChangeWorkoutCount() {
        updateContentUnavailableConfiguration()
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
