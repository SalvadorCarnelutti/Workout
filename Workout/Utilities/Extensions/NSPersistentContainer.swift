//
//  NSPersistentContainer.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//

import UIKit
import CoreData

extension NSPersistentContainer {
    func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveContext),
                                       name: UIApplication.willTerminateNotification,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(saveContext),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    @objc func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
