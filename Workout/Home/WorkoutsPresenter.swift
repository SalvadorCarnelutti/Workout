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

final class WorkoutsPresenter: BaseViewController {
    private var persistentContainer = NSPersistentContainer(name: "Workout")
    var viewWorkouts: WorkoutsPresenterToViewProtocol!
    var interactor: WorkoutsPresenterToInteractorProtocol!
    var router: WorkoutsPresenterToRouterProtocol!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
    override func loadView() {
        super.loadView()
        view = viewWorkouts
        persistentContainer.loadPersistentStores { [weak self] (persistentStoreDescription, error) in
            guard let self = self else { return }
            if let error = error {
                print("Unable to Add Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                print(self.persistentContainer.viewContext)
                self.viewWorkouts.loadView()
                self.setupNavigationBar()
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Workouts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            image: UIImage.add,
                                                            target: self,
                                                            action: #selector(newWorkoutTapped))
    }
    
    @objc private func newWorkoutTapped() {
//        router.pushWorkoutScreen()
    }
}

// MARK: - ViewToPresenterProtocol
extension WorkoutsPresenter: WorkoutsViewToPresenterProtocol {
    func viewLoaded() {}
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
