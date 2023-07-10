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
    func requestNotificationsSettings()
    func updateNotificationSettings(enabled: Bool)
}

// MARK: - PresenterToInteractorProtocol
final class AppSettingsInteractor: AppSettingsPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    let managedObjectContext: NSManagedObjectContext
    let notificationManager = NotificationManager.shared
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func requestNotificationsSettings() {
        notificationManager.requestNotificationsSettings()
    }
    
    func updateNotificationSettings(enabled: Bool) {
        notificationManager.updateNotificationSettings(enabled: enabled)
        if enabled { scheduleLocalNotifications() }
    }
    
    func scheduleLocalNotifications() {
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
    
    func scheduleLocalNotifications(for workout: Workout) {
        notificationManager.scheduleNotifications(for: workout.compactMappedSessions.map { SessionToNotificationMapper(session: $0).notificationRequest })
    }
}
