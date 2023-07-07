//
//  
//  WorkoutPresenter.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//
//

import UIKit

struct WorkoutSetting {
    let type: WorkoutSettingEnum
    let image: UIImage
    var name: String
    var description: () -> String
    
    mutating func updateName(with newName: String) { name = newName }
}

enum WorkoutSettingEnum {
    case editName
    case exercises
    case sessions
}

protocol WorkoutViewToPresenterProtocol: UIViewController {
    var workoutSettingsCount: Int { get }
    func workoutSetting(at indexPath: IndexPath) -> WorkoutSetting
    func didSelectRow(at indexPath: IndexPath)
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
    
    private lazy var workoutSettings: [WorkoutSetting] = [WorkoutSetting(type: .editName,
                                                                         image: .edit,
                                                                         name: interactor.workoutName,
                                                                         description: editNameDescription),
                                                          WorkoutSetting(type: .exercises,
                                                                         image: .exercise,
                                                                         name: "Exercises",
                                                                         description: exerciseDescription),
                                                          WorkoutSetting(type: .sessions,
                                                                         image: .time,
                                                                         name: "Sessions",
                                                                         description: sessionDescription)]
    
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
    
    private func editNameDescription() -> String {
        "Edit workout name"
    }
    
    private func exerciseDescription() -> String {
        let exercisesCount = interactor.exercisesCount
        let timedExercisesCount = interactor.timedExercisesCount
        let timedExercisesDuration = interactor.timedExercisesDuration
                
        switch (exercisesCount, timedExercisesCount) {
        case (0, _):
            return "Start adding exercises"
        case(_, 0):
            return "exercises_set".localizedWithFormat(exercisesCount)
        default:
            return "exercises_set_description".localizedWithFormat(exercisesCount, timedExercisesCount, timedExercisesDuration!)
        }
    }
    
    private func sessionDescription() -> String {
        let exercisesCount = interactor.exercisesCount
        let sessionsCount = interactor.sessionsCount

        switch (exercisesCount, sessionsCount) {
        case(0, _):
            return "Add at least one exercise"
        case (_, 0):
            return "Start adding sessions"
        default:
            return "sessions_set".localizedWithFormat(sessionsCount)
        }
    }
}

// MARK: - ViewToPresenterProtocol
extension WorkoutPresenter: WorkoutViewToPresenterProtocol {
    var workoutSettingsCount: Int { workoutSettings.count }
    
    func workoutSetting(at indexPath: IndexPath) -> WorkoutSetting { workoutSettings[indexPath.row] }
    
    // TODO: Disable add sessions when exercises count is 0 (Also remove sessions if exercises reach count 0)
    func didSelectRow(at indexPath: IndexPath) { router.handleWorkoutSettingRouting(for: workoutSetting(at: indexPath)) }
}

// MARK: - RouterToPresenterProtocol
extension WorkoutPresenter: WorkoutRouterToPresenterProtocol {
    func editWorkoutName(with newName: String) {
        interactor.editWorkoutName(with: newName)
        workoutSettings[0].updateName(with: newName)
        viewWorkout.reloadData()
    }
    
    var workout: Workout {
        interactor.workout
    }
    
    var workoutName: String {
        interactor.workoutName
    }
}
