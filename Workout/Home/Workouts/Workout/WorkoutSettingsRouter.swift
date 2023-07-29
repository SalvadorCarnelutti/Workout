////
////  
//  WorkoutSettingsRouter.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//
////
import UIKit

protocol WorkoutSettingsPresenterToRouterProtocol: AnyObject {
    var presenter: WorkoutSettingsRouterToPresenterProtocol? { get set }
    func handleWorkoutSettingRouting(for workoutSetting: WorkoutSetting)
    func handleNotificationTap(for workout: Workout)
}

// MARK: - PresenterToInteractorProtocol
final class WorkoutSettingsRouter: BaseRouter, WorkoutSettingsPresenterToRouterProtocol {
    // MARK: - Properties
    weak var presenter: WorkoutSettingsRouterToPresenterProtocol?
    
    func handleWorkoutSettingRouting(for workoutSetting: WorkoutSetting) {
        guard let workout = presenter?.workout else { return }
        
        switch workoutSetting.type {
        case .editName:
            presentEditWorkoutName()
        case .exercises:
            pushExercises(for: workout)
        case .sessions:
            pushSessions(for: workout)
        }
    }
    
    func presentEditWorkoutName() {
        guard let presenter = presenter else { return }
        
        let editWorkoutFormViewController = WorkoutFormConfigurator.resolveEdit(for: presenter.workoutName, completionAction: presenter.editWorkoutName)
        editWorkoutFormViewController.modalPresentationStyle = .popover
        presentedViewController?.present(editWorkoutFormViewController, animated: true)
    }
    
    func handleNotificationTap(for workout: Workout) {
        let exercisesViewController = ExercisesConfigurator.resolveEdit(for: workout)
        navigationController?.pushViewController(exercisesViewController, animated: false)
    }
    
    private func pushExercises(for workout: Workout) {
        let exercisesViewController = ExercisesConfigurator.resolveEdit(for: workout)
        navigationController?.pushViewController(exercisesViewController, animated: true)
    }
    
    private func pushSessions(for workout: Workout) {
        let sessionsViewController = SessionsConfigurator.resolve(for: workout)
        navigationController?.pushViewController(sessionsViewController, animated: true)
    }
}
