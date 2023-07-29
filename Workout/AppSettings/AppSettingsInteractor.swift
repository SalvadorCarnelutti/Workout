//
//  
//  AppSettingsInteractor.swift
//  Workout
//
//  Created by Salvador on 7/7/23.
//
//
import Foundation
import UserNotifications
import CoreData

protocol AppSettingsPresenterToInteractorProtocol: AnyObject {
    var presenter: AppSettingsInteractorToPresenterProtocol? { get set }
    var areNotificationsEnabled: Bool { get }
    var isDarkModeEnabled: Bool { get }
    var areHapticsEnabled: Bool { get }
    func requestNotificationsSettings()
    func toggleNotificationsSetting()
    func toggleDarkModeSetting()
    func toggleHapticsSetting()
}

// MARK: - PresenterToInteractorProtocol
final class AppSettingsInteractor: AppSettingsPresenterToInteractorProtocol {
    weak var presenter: AppSettingsInteractorToPresenterProtocol?
    let managedObjectContext: NSManagedObjectContext
    private let notificationsManager = NotificationsManager.shared
    private let appearanceManager = AppearanceManager.shared
    private let hapticsManager = HapticsManager.shared
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    var areNotificationsEnabled: Bool { notificationsManager.areNotificationsEnabled }
    
    var isDarkModeEnabled: Bool { appearanceManager.isDarkModeEnabled }
    
    var areHapticsEnabled: Bool { hapticsManager.areHapticsEnabled }
    
    func requestNotificationsSettings() {
        notificationsManager.requestNotificationsSettings()
    }
    
    func toggleNotificationsSetting() {
        notificationsManager.toggleNotificationsSetting()
        if areNotificationsEnabled { scheduleLocalNotifications() }
    }
    
    func toggleDarkModeSetting() {
        appearanceManager.toggleDarkModeSetting()
    }
    
    func toggleHapticsSetting() {
        hapticsManager.toggleHapticsSetting()
    }
    
    private func scheduleLocalNotifications() {
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        managedObjectContext.performAndWait {
            do {
                let workouts = try fetchRequest.execute()
                workouts.filter{ $0.sessionsCount > 0 }.forEach { scheduleLocalNotifications(for: $0) }
            } catch {
                presenter?.presentErrorMessage()
            }
        }
    }
    
    private func scheduleLocalNotifications(for workout: Workout) {
        let notificationRequests = workout.compactMappedSessions.map { SessionToNotificationMapper(session: $0).notificationRequest }
        notificationsManager.scheduleNotifications(for: notificationRequests)
    }
}
