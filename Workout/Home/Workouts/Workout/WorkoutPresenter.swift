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
    var isEnabled: Bool
    
    mutating func updateName(with newName: String) { name = newName }
    mutating func updateIsEnabled(with newStatus: Bool) { isEnabled = newStatus }
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
                                                                         description: editNameDescription,
                                                                         isEnabled: true),
                                                          WorkoutSetting(type: .exercises,
                                                                         image: .exercise,
                                                                         name: "Exercises",
                                                                         description: exerciseDescription,
                                                                         isEnabled: true),
                                                          WorkoutSetting(type: .sessions,
                                                                         image: .time,
                                                                         name: "Sessions",
                                                                         description: sessionDescription,
                                                                         isEnabled: interactor.areSessionsEnabled)]
    
    // workoutName can change as well as exercisesCount and sessionsCount
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        interactor.emptySessionsIfNeeded()
        updateSessionsSettingEnabledStatus()
        viewWorkout.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        view = viewWorkout
        viewWorkout.loadView()
        setupNavigationBar()
    }
    
    func handleNotificationTap(for workout: Workout) {
        router.handleNotificationTap(for: workout)
    }
    
    private func updateWorkoutName(with newName: String) {
        workoutSettings[0].updateName(with: newName)
    }
    
    private func updateSessionsSettingEnabledStatus() {
        workoutSettings[2].updateIsEnabled(with: interactor.areSessionsEnabled)
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
    
    func didSelectRow(at indexPath: IndexPath) {
        if workoutSettings[indexPath.row].isEnabled {
            router.handleWorkoutSettingRouting(for: workoutSetting(at: indexPath))
        } else {
            viewWorkout.denyTap(at: indexPath)
        }
    }
}

// MARK: - RouterToPresenterProtocol
extension WorkoutPresenter: WorkoutRouterToPresenterProtocol {
    func editWorkoutName(with newName: String) {
        interactor.editWorkoutName(with: newName)
        updateWorkoutName(with: newName)
        viewWorkout.reloadData()
    }
    
    var workout: Workout {
        interactor.workout
    }
    
    var workoutName: String {
        interactor.workoutName
    }
}
