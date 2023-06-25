//
//  Workout.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import CoreData

extension Workout {
    func setup(with name: String) {
        uuid = UUID()
        self.name = name
    }
    
    func update(with name: String) {
        self.name = name
    }
}
