//
//  Session.swift
//  Workout
//
//  Created by Salvador on 6/24/23.
//

import CoreData
import OSLog

extension Session {
    var weekday: Int { Int(day) }
    var uuidString: String? { uuid?.uuidString }
    var workoutName: String? { workout?.name }
    var longFormattedTimedExercisesDurationString: String? { workout?.longFormattedTimedExercisesDurationString }
    
    var formattedStartsAt: String {
        guard let startsAt = startsAt else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: startsAt)
        
        return formattedTime
    }
    
    func setup(with formOutput: SessionFormOutput, for workout: Workout) {
        uuid = UUID()
        day = Int16(formOutput.day)
        startsAt = formOutput.startsAt
        self.workout = workout
        Logger.coreData.info("New session \(self) added to managed object context")
    }
    
    func update(with formOutput: SessionFormOutput) {
        day = Int16(formOutput.day)
        startsAt = formOutput.startsAt
        Logger.coreData.info("Session updated to \(self) in current managed object context")
    }
    
    func delete() {
        managedObjectContext?.delete(self)
    }
}
