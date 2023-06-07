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
    func viewLoaded()
}

protocol WorkoutsInteractorToPresenterProtocol: BaseViewProtocol {
    func onPersistentContainerLoadSuccess()
    func onPersistentContainerLoadFailure(error: Error) -> ()
}

final class WorkoutsPresenter: BaseViewController {
    var viewWorkouts: WorkoutsPresenterToViewProtocol!
    var interactor: WorkoutsPresenterToInteractorProtocol!
    var router: WorkoutsPresenterToRouterProtocol!
    
    // TODO: Maybe change VIPER template
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
    override func loadView() {
        super.loadView()
        view = viewWorkouts
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
        router.pushAddWorkout(managedObjectContext: interactor.managedObjectContext)
    }
}

// MARK: - ViewToPresenterProtocol
extension WorkoutsPresenter: WorkoutsViewToPresenterProtocol {
    func viewLoaded() {}
}

extension WorkoutsPresenter: WorkoutsInteractorToPresenterProtocol {
    func onPersistentContainerLoadSuccess() {
        viewWorkouts.loadView()
        setupNavigationBar()
    }
    
    func onPersistentContainerLoadFailure(error: Error) {
        print("Unable to Add Persistent Store")
        print("\(error), \(error.localizedDescription)")
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
