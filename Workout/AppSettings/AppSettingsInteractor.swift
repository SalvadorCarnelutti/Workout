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
    func scheduleLocalNotifications()
    func removeAllPendingNotificationRequests()
}

// MARK: - PresenterToInteractorProtocol
final class AppSettingsInteractor: AppSettingsPresenterToInteractorProtocol {
    weak var presenter: BaseViewProtocol?
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func scheduleLocalNotifications() {
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        managedObjectContext.performAndWait {
            do {
                // Execute Fetch Request
                let workouts = try fetchRequest.execute()
                workouts.forEach { scheduleLocalNotifications(for: $0) }
            } catch {
                // TODO: Handle error gracefully
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }
    
    func removeAllPendingNotificationRequests() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func scheduleLocalNotifications(for workout: Workout) {
        guard workout.sessionsCount > 0, let workoutName = workout.name else { return }
        
        for session in workout.compactMappedSessions {
            guard let startsAt = session.startsAt, let uuidString = session.uuid?.uuidString else { return }
            
            // Configure Notification Content
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = workoutName
            notificationContent.subtitle = "Your session is about to begin"
            if let longFormattedTimedExercisesDurationString = workout.longFormattedTimedExercisesDurationString {
                notificationContent.body = "You'll need at least \(longFormattedTimedExercisesDurationString) to complete this workout"
            }
            
            // Add Trigger
            var dateComponents = DateComponents()
            let calendar = Calendar.current
            dateComponents.calendar = calendar
            
            let weekday = session.weekday
            let hour = calendar.component(.hour, from: startsAt)
            let minute = calendar.component(.minute, from: startsAt)
            
            dateComponents.weekday = weekday
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            // Create the trigger as a repeating event.
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            // Create Notification Request
            let notificationRequest = UNNotificationRequest(identifier: uuidString, content: notificationContent, trigger: notificationTrigger)

            // Add Request to User Notification Center
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
        }
    }
}
