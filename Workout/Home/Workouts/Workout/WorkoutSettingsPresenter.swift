//
//  
//  WorkoutSettingsPresenter.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//
//

import UIKit

protocol WorkoutSettingsViewToPresenterProtocol: AnyObject {
    var view: WorkoutSettingsPresenterToViewProtocol! { get set }
    var workoutSettingsCount: Int { get }
    var areHapticsEnabled: Bool { get }
    func workoutSetting(at indexPath: IndexPath) -> WorkoutSetting
    func didSelectRow(at indexPath: IndexPath)
    func emptySessionsIfNeeded()
    func updateSessionsSettingEnabledStatus()
    func handleNotificationTap(for workout: Workout)
}

protocol WorkoutSettingsRouterToPresenterProtocol: AnyObject {
    var workout: Workout { get }
    var workoutName: String { get }
    func editWorkoutName(with newName: String)
}

typealias WorkoutSettingsPresenterProtocol = WorkoutSettingsViewToPresenterProtocol & WorkoutSettingsRouterToPresenterProtocol

final class WorkoutSettingsPresenter: WorkoutSettingsPresenterProtocol {
    weak var view: WorkoutSettingsPresenterToViewProtocol!
    let interactor: WorkoutSettingsPresenterToInteractorProtocol
    let router: WorkoutSettingsPresenterToRouterProtocol
    
    private lazy var workoutSettings: [WorkoutSetting] = [editNameWorkoutSetting,
                                                          exercisesWorkoutSetting,
                                                          sessionsWorkoutSetting]
    
    init(interactor: WorkoutSettingsPresenterToInteractorProtocol, router: WorkoutSettingsPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        router.presenter = self
    }
    
    private var editNameWorkoutSetting: WorkoutSetting {
        WorkoutSetting(type: .editName,
                       image: .edit,
                       name: interactor.workoutName,
                       description: editNameDescription,
                       isEnabled: true)
    }
    
    private var exercisesWorkoutSetting: WorkoutSetting {
        WorkoutSetting(type: .exercises,
                       image: .exercise,
                       name: String(localized: "Exercises"),
                       description: exerciseDescription,
                       isEnabled: true)
    }
    
    private var sessionsWorkoutSetting: WorkoutSetting {
        WorkoutSetting(type: .sessions,
                       image: .time,
                       name: String(localized: "Sessions"),
                       description: sessionDescription,
                       isEnabled: interactor.areSessionsEnabled)
    }
    
    private func updateWorkoutName(with newName: String) {
        workoutSettings[0].updateName(with: newName)
    }
    
    private func editNameDescription() -> String { String(localized: "Edit workout name") }
    
    private func exerciseDescription() -> String {
        let exercisesCount = interactor.exercisesCount
        let timedExercisesCount = interactor.timedExercisesCount
        let timedExercisesDuration = interactor.timedExercisesDuration
                
        switch (exercisesCount, timedExercisesCount) {
        case (0, _):
            return String(localized: "Start adding exercises")
        case(_, 0):
            return "exercisesSet".localizedWithFormat(exercisesCount)
        default:
            return String(localized: "\(exercisesCount) set, where \(timedExercisesCount) timed for \(timedExercisesDuration!)")
        }
    }
    
    private func sessionDescription() -> String {
        let exercisesCount = interactor.exercisesCount
        let sessionsCount = interactor.sessionsCount

        switch (exercisesCount, sessionsCount) {
        case(0, _):
            return String(localized: "Add at least one exercise")
        case (_, 0):
            return String(localized: "Start adding sessions")
        default:
            return "sessionsSet".localizedWithFormat(sessionsCount)
        }
    }
}

// MARK: - ViewToPresenterProtocol
extension WorkoutSettingsPresenter {
    var workoutSettingsCount: Int { workoutSettings.count }
    
    var areHapticsEnabled: Bool { interactor.areHapticsEnabled }
    
    func workoutSetting(at indexPath: IndexPath) -> WorkoutSetting { workoutSettings[indexPath.row] }
    
    func didSelectRow(at indexPath: IndexPath) {
        if workoutSettings[indexPath.row].isEnabled {
            router.handleWorkoutSettingRouting(for: workoutSetting(at: indexPath))
        } else {
            view.denyTap(at: indexPath)
        }
    }
    
    func emptySessionsIfNeeded() { interactor.emptySessionsIfNeeded() }
    
    func updateSessionsSettingEnabledStatus() { workoutSettings[2].updateIsEnabled(with: interactor.areSessionsEnabled) }
    
    func handleNotificationTap(for workout: Workout) { router.handleNotificationTap(for: workout) }
}

// MARK: - RouterToPresenterProtocol
extension WorkoutSettingsPresenter {
    func editWorkoutName(with newName: String) {
        interactor.editWorkoutName(with: newName)
        updateWorkoutName(with: newName)
        view.reloadData()
    }
    
    var workout: Workout {
        interactor.workout
    }
    
    var workoutName: String {
        interactor.workoutName
    }
}
