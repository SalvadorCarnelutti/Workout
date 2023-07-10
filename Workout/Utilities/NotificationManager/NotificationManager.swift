//
//  NotificationManager.swift
//  Workout
//
//  Created by Salvador on 7/8/23.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notificationSettingsKey = "NotificationSettings"
    
    var areNotificationsEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: notificationSettingsKey) }
        set { UserDefaults.standard.set(newValue, forKey: notificationSettingsKey) }
    }

    private init() {}
    
    private func removeAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    private func enableNotifications() {
        areNotificationsEnabled = true
    }
    
    private func disableNotifications() {
        areNotificationsEnabled = false
        removeAllNotifications()
    }
    
    func updateNotificationSettings(enabled: Bool) {
        enabled ? enableNotifications() : disableNotifications()
    }
    
    func scheduleNotification(for notification: UNNotificationRequest) {
        guard areNotificationsEnabled else { return }
        
        notificationCenter.add(notification) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func scheduleNotifications(for notifications: [UNNotificationRequest]) {
        guard areNotificationsEnabled else { return }
        
        notifications.forEach { scheduleNotification(for: $0) }
    }
    
    func updateNotification(for notification: UNNotificationRequest) {
        guard areNotificationsEnabled else { return }
        
        removeNotification(for: notification.identifier)
        scheduleNotification(for: notification)
    }
    
    func removeNotification(for notificationIdentifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }
    
    func removeNotifications(for notificationIdentifiers: [String]) {
        notificationIdentifiers.forEach { removeNotification(for: $0) }
    }
}

extension NotificationManager {
    func requestNotificationsSettings() {
        // Request Notification Settings
        notificationCenter.getNotificationSettings { notificationSettings in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { success in
                    self.updateNotificationSettings(enabled: success)
                })
            case .authorized:
                self.enableNotifications()
            default:
                return
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            // TODO: Handle error handling
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }

            completionHandler(success)
        }
    }
}
