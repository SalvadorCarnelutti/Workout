//
//  WorkoutFormModels.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//

struct WorkoutFormModel {
    let formInput: String?
    let formStyle: FormStyle
    let completionAction: ((String) -> ())
}
