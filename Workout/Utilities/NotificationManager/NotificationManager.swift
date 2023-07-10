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
    
    func toggleNotificationsSetting() {
        areNotificationsEnabled.toggle()
        areNotificationsEnabled ? enableNotifications() : disableNotifications()
    }
    
    func scheduleNotifications(for notifications: [UNNotificationRequest]) {
        notifications.forEach { scheduleNotification(for: $0) }
    }
    
    func removeNotifications(for notificationIdentifiers: [String]) {
        notificationIdentifiers.forEach { removeNotification(for: $0) }
    }
    
    func updateNotifications(for notifications: [UNNotificationRequest]) {
        notifications.forEach { updateNotification(for: $0) }
    }
    
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
    
    private func scheduleNotification(for notification: UNNotificationRequest) {
        guard areNotificationsEnabled else { return }
        
        // TODO: Handle error properly
        notificationCenter.add(notification) { error in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    private func removeNotification(for notificationIdentifier: String) {
        guard areNotificationsEnabled else { return }
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }
    
    private func updateNotification(for notification: UNNotificationRequest) {
        guard areNotificationsEnabled else { return }
        
        removeNotification(for: notification.identifier)
        scheduleNotification(for: notification)
    }
}

extension NotificationManager {
    func requestNotificationsSettings() {
        // Request Notification Settings
        notificationCenter.getNotificationSettings { notificationSettings in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { success in
                    if success { self.toggleNotificationsSetting() }
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
