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
    func workoutAt(indexPath: IndexPath) -> Workout
    func didSelectRowAt(_ indexPath: IndexPath)
}

protocol WorkoutsInteractorToPresenterProtocol: BaseViewProtocol {
    func onPersistentContainerLoadSuccess()
    func onPersistentContainerLoadFailure(error: Error) -> ()
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Workout.name), ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: interactor.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
    }()
    
    override func loadView() {
        super.loadView()
        view = viewWorkout
        // TODO: have to include a loader item in the project. I still need to do Workout name editing available. Fix Texfield error messages. Validate entities model values. After all of this I could actually look into setting scheduled sessions for for assigned workouts.
        interactor.loadPersistentContainer()
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
    
    func workoutAt(indexPath: IndexPath) -> Workout {
        fetchedResultsController.object(at: indexPath)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        router.pushEditWorkout(for: fetchedResultsController.object(at: indexPath))
    }
}

// MARK: - InteractorToPresenterProtocol
extension WorkoutsPresenter: WorkoutsInteractorToPresenterProtocol {
    func onPersistentContainerLoadSuccess() {
        viewWorkout.loadView()
        setupNavigationBar()
    }
    
    func onPersistentContainerLoadFailure(error: Error) {
        print("Unable to Add Persistent Store")
        print("\(error), \(error.localizedDescription)")
    }
}

// MARK: - RouterToPresenterProtocol
extension WorkoutsPresenter: WorkoutsRouterToPresenterProtocol {
    func addCompletionAction(name: String) {
        interactor.addCompletionAction(name: name)
    }
}

class BaseViewController: UIViewController, BaseViewProtocol {
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
}

protocol BaseViewProtocol: AnyObject {
    func showLoader()
    func hideLoader()
}
