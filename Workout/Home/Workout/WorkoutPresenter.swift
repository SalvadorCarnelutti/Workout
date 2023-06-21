//
//  
//  WorkoutPresenter.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//
//

import UIKit

enum WorkoutSection {
    case edit(String)
    case exercises
    case sessions
    
    var name: String {
        switch self {
        case .edit(let name):
            return name
        case .exercises:
            return "Exercises"
        case .sessions:
            return "Sessions"
        }
    }
    
    var image: UIImage {
        switch self {
        case .edit:
            return .edit
        case .exercises:
            return .exercise
        case .sessions:
            return .time
        }
    }
}

protocol WorkoutViewToPresenterProtocol: UIViewController {
    var sectionsCount: Int { get }
    func workoutSectionAt(section: Int) -> WorkoutSection
    func setupWorkoutSectionDelegate(for header: WorkoutSectionTableViewHeader)
}

protocol WorkoutRouterToPresenterProtocol: UIViewController {
    var workout: Workout { get }
    var workoutName: String { get }
    func editWorkoutName(with newName: String)
}

final class WorkoutPresenter: BaseViewController {
    var viewWorkout: WorkoutPresenterToViewProtocol!
    var interactor: WorkoutPresenterToInteractorProtocol!
    var router: WorkoutPresenterToRouterProtocol!
    
    private lazy var workoutSections: [WorkoutSection] = [.edit(interactor.workoutName),
                                                          .exercises,
                                                          .sessions]
    
    override func loadView() {
        super.loadView()
        view = viewWorkout
        viewWorkout.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Workout"
    }
}

// MARK: - ViewToPresenterProtocol
extension WorkoutPresenter: WorkoutViewToPresenterProtocol {
    var sectionsCount: Int {
        workoutSections.count
    }
    
    func workoutSectionAt(section: Int) -> WorkoutSection {
        workoutSections[section]
    }
    
    func setupWorkoutSectionDelegate(for header: WorkoutSectionTableViewHeader) {
        header.delegate = self
    }
}

// MARK: - RouterToPresenterProtocol
extension WorkoutPresenter: WorkoutRouterToPresenterProtocol {
    func editWorkoutName(with newName: String) {
        interactor.editWorkoutName(with: newName)
        workoutSections[0] = .edit(newName)
        viewWorkout.updateSections()
    }
    
    var workout: Workout {
        interactor.workout
    }
    
    var workoutName: String {
        interactor.workoutName
    }
}

// MARK: - WorkoutSectionTableViewHeaderDelegate protocol
extension WorkoutPresenter: WorkoutSectionTableViewHeaderDelegate {
    func customHeaderViewDidTapSection(at section: WorkoutSection) {
        router.handleSectionRouting(for: section)
    }
}
