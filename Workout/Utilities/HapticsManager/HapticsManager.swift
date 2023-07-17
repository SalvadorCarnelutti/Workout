//
//  HapticsManager.swift
//  Workout
//
//  Created by Salvador on 7/16/23.
//

import Foundation

class HapticsManager {
    static let shared = HapticsManager()
    private let hapticsSettingsKey = "HapticsSettings"
    
    var areHapticsEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: hapticsSettingsKey) }
        set { UserDefaults.standard.set(newValue, forKey: hapticsSettingsKey) }
    }

    private init() {}
    
    func toggleHapticsSetting() {
        areHapticsEnabled.toggle()
    }
}
