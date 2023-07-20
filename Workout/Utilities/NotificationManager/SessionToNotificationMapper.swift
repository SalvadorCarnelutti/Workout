//
//  SessionToNotificationMapper.swift
//  Workout
//
//  Created by Salvador on 7/9/23.
//

import NotificationCenter
import CoreData

// TODO: See if there is better way to handle optionals and even if this should adopt a protocol of sorts
struct SessionToNotificationMapper {
    let session: Session
    
    private var notificationContent: UNMutableNotificationContent {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = session.workoutName ?? ""
        notificationContent.subtitle = String(localized: "Your session is about to begin")
        if let longFormattedTimedExercisesDurationString = session.longFormattedTimedExercisesDurationString {
            notificationContent.body = String(localized: "You'll need at least \(longFormattedTimedExercisesDurationString) to complete this workout")
        }
        
        return notificationContent
    }
    
    private var notificationTrigger: UNCalendarNotificationTrigger {
        // TODO: Decide how much earlier the user gets notified
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        dateComponents.calendar = calendar
        
        let weekday = session.weekday
        let hour = calendar.component(.hour, from: session.startsAt ?? Date())
        let minute = calendar.component(.minute, from: session.startsAt ?? Date())
        
        dateComponents.weekday = weekday
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        return notificationTrigger
    }
    
    var notificationIdentifier: String { session.uuidString ?? "" }
    
    var notificationRequest: UNNotificationRequest {
        UNNotificationRequest(identifier: notificationIdentifier,
                              content: notificationContent,
                              trigger: notificationTrigger)
    }
}
