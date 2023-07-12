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
    var presenter: BaseViewProtocol? { get set }
    var areNotificationsEnabled: Bool { get }
    var isDarkModeEnabled: Bool { get }
    func requestNotificationsSettings()
    func toggleNotificationsSetting()
    func toggleDarkModeSetting()
}

// MARK: - PresenterToInteractorProtocol
final class AppSettingsInteractor: AppSettingsPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    let managedObjectContext: NSManagedObjectContext
    private let notificationManager = NotificationManager.shared
    private let appearanceManager = AppearanceManager.shared
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    var areNotificationsEnabled: Bool { notificationManager.areNotificationsEnabled }
    
    var isDarkModeEnabled: Bool { appearanceManager.isDarkModeEnabled }
    
    func requestNotificationsSettings() {
        notificationManager.requestNotificationsSettings()
    }
    
    func toggleNotificationsSetting() {
        notificationManager.toggleNotificationsSetting()
        if areNotificationsEnabled {
            scheduleLocalNotifications()
            setupNotificationsHandling()
        }
    }
    
    func toggleDarkModeSetting() {
        appearanceManager.toggleDarkModeSetting()
    }
    
    private func scheduleLocalNotifications() {
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        managedObjectContext.performAndWait {
            do {
                let workouts = try fetchRequest.execute()
                workouts.forEach { scheduleLocalNotifications(for: $0) }
            } catch {
                presenter?.presentErrorMessage()
            }
        }
    }
    
    private func scheduleLocalNotifications(for workout: Workout) {
        let notificationRequests = workout.compactMappedSessions.map { SessionToNotificationMapper(session: $0).notificationRequest }
        notificationManager.scheduleNotifications(for: notificationRequests)
    }
    
    private func setupNotificationsHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange),
                                       name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: managedObjectContext)
    }
    
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            let notificationRequestsToSchedule = inserts.compactMap { $0 as? Session }.map { SessionToNotificationMapper(session: $0).notificationRequest }
            notificationManager.scheduleNotifications(for: notificationRequestsToSchedule)
        }

        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            let notificationRequestsToUpdate = updates.compactMap { $0 as? Session }.map { SessionToNotificationMapper(session: $0).notificationRequest }
            notificationManager.updateNotifications(for: notificationRequestsToUpdate)
        }

        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            let notificationRequestsToRemove = deletes.compactMap { $0 as? Session }.map { SessionToNotificationMapper(session: $0).notificationIdentifier }
            notificationManager.removeNotifications(for: notificationRequestsToRemove)
        }
    }
}
