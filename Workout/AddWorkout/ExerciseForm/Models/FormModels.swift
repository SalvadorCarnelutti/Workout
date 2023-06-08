//
//  FormModels.swift
//  Workout
//
//  Created by Salvador on 6/5/23.
//

import Foundation

enum FormStyle {
    case add
    case edit
}

struct WorkoutFormModel {
    let formInput: String?
    let formStyle: FormStyle
    let completionAction: ((String) -> ())
}

struct ExerciseFormModel {
    let formInput: FormInput?
    let formStyle: FormStyle
    let completionAction: ((FormOutput) -> ())
}

struct FormInput {
    var name: String?
    var duration: String?
    var sets: String?
    var reps: String?
    
    init(exercise: Exercise) {
        self.name = exercise.name
        self.duration = exercise.durationString
        self.sets = exercise.setsString
        self.reps = exercise.repsString
    }
}

struct FormOutput {
    var name: String
    var duration: Int
    var sets: Int
    var reps: Int
}
