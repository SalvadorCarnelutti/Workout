//
//  AppearanceManager.swift
//  Workout
//
//  Created by Salvador on 7/12/23.
//

import UIKit

enum AppearanceMode: String {
    case light
    case dark
    case system
}

class AppearanceManager {
    static let shared = AppearanceManager()
    private let appearanceModeKey = "AppearanceModeKey"
    
    var isDarkModeEnabled: Bool { selectedMode == .dark }
    
    private var selectedMode: AppearanceMode {
        get {
            if let storedMode = UserDefaults.standard.string(forKey: appearanceModeKey),
               let mode = AppearanceMode(rawValue: storedMode) {
                return mode
            }
            return .system
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: appearanceModeKey)
        }
    }
    
    func toggleDarkModeSetting() {
        switch selectedMode {
        case .light, .system:
            selectedMode = .dark
        case .dark:
            selectedMode = .light
        }
        
        updateAppearanceMode()
    }
    
    private init() {}
    
    func updateAppearanceMode() {
        let appearanceMode = AppearanceManager.shared.selectedMode
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            switch appearanceMode {
            case .light:
                // Set the light appearance mode
                window.overrideUserInterfaceStyle = .light
            case .dark:
                // Set the dark appearance mode
                window.overrideUserInterfaceStyle = .dark
            case .system:
                // Set the system appearance mode
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}
