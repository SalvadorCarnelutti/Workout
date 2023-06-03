//
//  
//  AddWorkoutPresenter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//

import UIKit

protocol AddWorkoutViewToPresenterProtocol: UIViewController {
    func viewLoaded()
}

final class AddWorkoutPresenter: BaseViewController {
    var viewAddWorkout: AddWorkoutPresenterToViewProtocol!
    var interactor: AddWorkoutPresenterToInteractorProtocol!
    var router: AddWorkoutPresenterToRouterProtocol!
    
    override func loadView() {
        super.loadView()
        view = viewAddWorkout
        viewAddWorkout.loadView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Workouts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            image: UIImage.add,
                                                            target: self,
                                                            action: #selector(addExerciseTapped))
    }
    
    @objc private func addExerciseTapped() {
        router.presentExerciseForm()
    }
}

// MARK: - ViewToPresenterProtocol
extension AddWorkoutPresenter: AddWorkoutViewToPresenterProtocol {
    func viewLoaded() {}
}
