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
    
    var rowCount: Int {
        switch self {
        case .edit:
            return 0
        default:
            return 1
        }
    }
}

protocol WorkoutViewToPresenterProtocol: UIViewController {
    var sectionsCount: Int { get }
    func rowCount(at section: Int) -> Int
    func workoutSection(at section: Int) -> WorkoutSection
    func setupWorkoutSectionDelegate(for header: WorkoutSectionTableViewHeader)
    func workoutRow(at section: Int) -> String
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
    
    // workoutName can change as well as exercisesCount and sessionsCount
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWorkout.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        view = viewWorkout
        viewWorkout.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Workout"
    }
    
    private var exerciseRow: String {
        let exercisesCount = interactor.exercisesCount
        let timedExercisesCount = interactor.timedExercisesCount
        
        switch (exercisesCount, timedExercisesCount) {
        case (0, _):
            return "Start adding exercises"
        case(_, 0):
            return "\(exercisesCount) exercises"
        default:
            // TODO: Fix singular vs plural cases
            return "\(exercisesCount) exercises where \(timedExercisesCount) are timed for \(interactor.timedExercisesDurationString) minutes"
        }
    }
    
    private var sessionRow: String {
        let exercisesCount = interactor.exercisesCount
        let sessionsCount = interactor.sessionsCount
        
        switch (exercisesCount, sessionsCount) {
        case(0, _):
            return "Add at least one exercise"
        case (_, 0):
            return "Start adding sessions"
        default:
            return "\(sessionsCount) sessions set"
        }
    }
}

// MARK: - ViewToPresenterProtocol
extension WorkoutPresenter: WorkoutViewToPresenterProtocol {
    var sectionsCount: Int {
        workoutSections.count
    }
    
    func workoutSection(at section: Int) -> WorkoutSection {
        workoutSections[section]
    }
    
    func workoutRow(at section: Int) -> String {
        switch workoutSections[section] {
        case .exercises:
            return exerciseRow
        case .sessions:
            return sessionRow
        default:
            return ""
        }
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
    }
    
    func rowCount(at section: Int) -> Int {
        workoutSections[section].rowCount
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
