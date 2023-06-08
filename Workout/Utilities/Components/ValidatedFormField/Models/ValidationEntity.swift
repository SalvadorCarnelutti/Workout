//
//  ValidationEntity.swift
//  Workout
//
//  Created by Salvador on 6/8/23.
//

import UIKit
struct ValidationEntity {
    var validationBlock: ((String) -> Bool)
    var errorMessage: String = "Invalid input"
    var placeholder: String
}
