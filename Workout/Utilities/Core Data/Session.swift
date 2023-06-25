//
//  Session.swift
//  Workout
//
//  Created by Salvador on 6/24/23.
//

import CoreData

extension Session {
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
    }
    
    func update(with formOutput: SessionFormOutput) {
        day = Int16(formOutput.day)
        startsAt = formOutput.startsAt
    }
}
