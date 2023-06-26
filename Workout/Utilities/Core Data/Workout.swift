//
//  Workout.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import CoreData

extension Workout {
    var exercisesCount: Int {
        exercises?.count ?? 0
    }
    
    var duration: Int {
        exercises?.compactMap { $0 as? Exercise }.reduce (0, { $0 + Int($1.duration) }) ?? 0
    }
    
    func setup(with name: String) {
        uuid = UUID()
        self.name = name
    }
    
    func update(with name: String) {
        self.name = name
    }
}
