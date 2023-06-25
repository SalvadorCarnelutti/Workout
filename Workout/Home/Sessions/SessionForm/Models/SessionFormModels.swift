//
//  SessionFormModels.swift
//  Workout
//
//  Created by Salvador on 6/24/23.
//

import Foundation

struct SessionFormModel {
    let formInput: SessionFormInput?
    let formStyle: FormStyle
    let completionAction: ((SessionFormOutput) -> ())
}

struct SessionFormInput {
    var day: Int
    var startsAt: Date
    
    init(session: Session) {
        day = Int(session.day)
        startsAt = session.startsAt!
    }
}

struct SessionFormOutput {
    var day: Int
    var startsAt: Date
}
