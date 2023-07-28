//
//  WorkoutModels.swift
//  Workout
//
//  Created by Salvador on 7/28/23.
//

import UIKit

struct WorkoutSetting {
    let type: WorkoutSettingEnum
    let image: UIImage
    var name: String
    var description: () -> String
    var isEnabled: Bool
    
    mutating func updateName(with newName: String) { name = newName }
    mutating func updateIsEnabled(with newStatus: Bool) { isEnabled = newStatus }
}

enum WorkoutSettingEnum {
    case editName
    case exercises
    case sessions
}
