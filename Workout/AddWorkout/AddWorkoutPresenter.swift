//
//  
//  AddWorkoutPresenter.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//

import UIKit
import CoreData

protocol AddWorkoutViewToPresenterProtocol: UIViewController {
    var managedObjectContext: NSManagedObjectContext { get }
    var exercisesCount: Int { get }
    func viewLoaded()
    func exerciseAt(_ index: Int) -> Exercise
    func didSelectRowAt(_ index: Int)
    func deleteExerciseAt(_ index: Int)
    func moveExerciseAt(from: Int, to: Int)
}

final class AddWorkoutPresenter: BaseViewController {
    var viewAddWorkout: AddWorkoutPresenterToViewProtocol!
    var interactor: AddWorkoutPresenterToInteractorProtocol!
    var router: AddWorkoutPresenterToRouterProtocol!
    
    override func loadView() {
        super.loadView()
        view = viewAddWorkout
        viewAddWorkout.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Workout"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            image: UIImage.add,
                                                            target: self,
                                                            action: #selector(addExerciseTapped))
    }
    
    @objc private func addExerciseTapped() {
        router.presentAddExerciseForm()
    }
}

// MARK: - ViewToPresenterProtocol
extension AddWorkoutPresenter: AddWorkoutViewToPresenterProtocol {
    var managedObjectContext: NSManagedObjectContext {
        interactor.managedObjectContext
    }
    
    var exercisesCount: Int {
        interactor.exercisesCount
    }
    
    func viewLoaded() {}
    
    func didSelectRowAt(_ index: Int) {
        router.presentEditExerciseForm(for: interactor.exerciseAt(index))
    }
    
    func exerciseAt(_ index: Int) -> Exercise {
        interactor.exerciseAt(index)
    }
    
    func deleteExerciseAt(_ index: Int) {
        interactor.deleteExerciseAt(index)
    }
    
    func moveExerciseAt(from: Int, to: Int) {
        interactor.moveExerciseAt(from: from, to: to)
    }
}
