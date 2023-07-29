//
//  AppSettingModels.swift
//  Workout
//
//  Created by Salvador on 7/28/23.
//

import UIKit

struct AppSetting {
    var isOn: Bool {
        didSet {
            toggleAction()
        }
    }
    
    let toggleImageModel: ToggleImageModel
    var name: String
    var toggleAction: () -> ()
    
    mutating func toggle() { isOn.toggle() }
}
