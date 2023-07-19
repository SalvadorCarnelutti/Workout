//
//  Logger.swift
//  Workout
//
//  Created by Salvador on 7/18/23.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let coreData = Logger(subsystem: subsystem, category: "coreData")
    static let notificationsManager = Logger(subsystem: subsystem, category: "userNotifications")
    static let appearanceManager = Logger(subsystem: subsystem, category: "appearanceManager")
    static let hapticsManager = Logger(subsystem: subsystem, category: "hapticsManager")
}
