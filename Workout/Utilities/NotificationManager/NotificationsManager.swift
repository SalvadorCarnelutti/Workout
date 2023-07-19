//
//  NotificationsManager.swift
//  Workout
//
//  Created by Salvador on 7/8/23.
//

import UserNotifications
import OSLog

class NotificationsManager {
    static let shared = NotificationsManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notificationSettingsKey = "NotificationSettings"
    
    var areNotificationsEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: notificationSettingsKey) }
        set { UserDefaults.standard.set(newValue, forKey: notificationSettingsKey) }
    }

    private init() {}
    
    func toggleNotificationsSetting() {
        areNotificationsEnabled.toggle()
        areNotificationsEnabled ? enableNotifications() : disableNotifications()
    }
    
    func scheduleNotifications(for notifications: [UNNotificationRequest]) {
        Logger.notificationsManager.info("Scheduling \(notifications.count) new notifications")
        notifications.forEach { scheduleNotification(for: $0) }
    }
    
    func removeNotifications(for notificationIdentifiers: [String]) {
        Logger.notificationsManager.info("Removing previous \(notificationIdentifiers.count) notifications")
        notificationIdentifiers.forEach { removeNotification(for: $0) }
    }
    
    func updateNotifications(for notifications: [UNNotificationRequest]) {
        Logger.notificationsManager.info("Updating previous \(notifications.count) notifications")
        notifications.forEach { updateNotification(for: $0) }
    }
    
    private func removeAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        Logger.notificationsManager.info("All pending notifications removed")
    }

    private func enableNotifications() {
        areNotificationsEnabled = true
        Logger.notificationsManager.info("User notifications setting turned on")
    }
    
    private func disableNotifications() {
        areNotificationsEnabled = false
        Logger.notificationsManager.info("User notifications setting turned off")
        removeAllNotifications()
    }
    
    func scheduleNotification(for notification: UNNotificationRequest) {
        guard areNotificationsEnabled else { return }
        Logger.notificationsManager.info("Adding new notification of identifier \(notification.identifier)")
        
        // TODO: Handle error properly
        notificationCenter.add(notification) { error in
            if let error = error {
                Logger.notificationsManager.error("Unable to add notification request of identifier \(notification.identifier): Error (\(error))")
            } else {
                Logger.notificationsManager.info("New notification of identifier \(notification.identifier), added successfully")
            }
        }
    }
    
    func removeNotification(for notificationIdentifier: String) {
        guard areNotificationsEnabled else { return }
        
        Logger.notificationsManager.info("Removing previous notification of identifier: \(notificationIdentifier)")
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }
    
    func updateNotification(for notification: UNNotificationRequest) {
        guard areNotificationsEnabled else { return }
        
        Logger.notificationsManager.info("Updating previous notification of identifier: \(notification.identifier)")
        removeNotification(for: notification.identifier)
        scheduleNotification(for: notification)
    }
}

extension NotificationsManager {
    func requestNotificationsSettings() {
        notificationCenter.getNotificationSettings { notificationSettings in
            if case .notDetermined = notificationSettings.authorizationStatus {
                self.requestAuthorization(completionHandler: { success in
                    if success { self.enableNotifications() }
                })
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            // TODO: Handle error handling
            if let error = error {
                print("Request authorization failed (\(error))")
            }

            completionHandler(success)
        }
    }
}
