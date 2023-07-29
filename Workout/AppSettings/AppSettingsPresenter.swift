//
//  
//  AppSettingsPresenter.swift
//  Workout
//
//  Created by Salvador on 7/7/23.
//
//

import Foundation

protocol AppSettingsViewToPresenterProtocol: AnyObject {
    var view: AppSettingsPresenterToViewProtocol! { get set }
    var appSettingCount: Int { get }
    func viewLoaded()
    func appSetting(at indexPath: IndexPath) -> AppSetting
    func didSwitchValue(at indexPath: IndexPath)
}

protocol AppSettingsInteractorToPresenterProtocol: AnyObject {
    func presentErrorMessage()
}

protocol AppSettingsRouterToPresenterProtocol: AnyObject {}

typealias AppSettingsProtocol = AppSettingsViewToPresenterProtocol & AppSettingsInteractorToPresenterProtocol & AppSettingsRouterToPresenterProtocol

final class AppSettingsPresenter: AppSettingsProtocol {
    weak var view: AppSettingsPresenterToViewProtocol!
    let interactor: AppSettingsPresenterToInteractorProtocol
    let router: AppSettingsPresenterToRouterProtocol
    
    private lazy var appSettings = [notificationsAppSetting,
                                    darkModeAppSetting,
                                    hapticsAppSetting]
    
    init(interactor: AppSettingsPresenterToInteractorProtocol, router: AppSettingsPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        interactor.presenter = self
    }
    
    private var notificationsAppSetting: AppSetting {
        let areNotificationsEnabled = interactor.areNotificationsEnabled
        
        return AppSetting(isOn: areNotificationsEnabled,
                          toggleImageModel: ToggleImageModel(asDefault: areNotificationsEnabled,
                                                             defaultImage: .notificationsOff,
                                                             defaultBackgroundColor: .systemRed,
                                                             alternateImage: .notificationsOn,
                                                             alternateBackgroundColor: .systemRed),
                          name: String(localized: "Notifications"),
                          toggleAction: toggleNotificationsSetting)
    }
    
    private var darkModeAppSetting: AppSetting {
        let isDarkModeEnabled = interactor.isDarkModeEnabled
        
        return AppSetting(isOn: isDarkModeEnabled,
                          toggleImageModel: ToggleImageModel(asDefault: isDarkModeEnabled,
                                                             defaultImage: .darkModeOff,
                                                             defaultBackgroundColor: .systemBlue,
                                                             alternateImage: .darkModeOn,
                                                             alternateBackgroundColor: .label),
                          name: String(localized: "Dark Mode"),
                          toggleAction: toggleDarkMode)
    }
    
    private var hapticsAppSetting: AppSetting {
        let isHapticsEnabled = interactor.areHapticsEnabled
        
        return AppSetting(isOn: isHapticsEnabled,
                          toggleImageModel: ToggleImageModel(asDefault: isHapticsEnabled,
                                                             defaultImage: .hapticsOff,
                                                             defaultBackgroundColor: .systemGreen,
                                                             alternateImage: .hapticsOn,
                                                             alternateBackgroundColor: .systemGreen),
                          name: String(localized: "Haptics"),
                          toggleAction: toggleHaptics)
    }
    
    private func toggleNotificationsSetting() { interactor.toggleNotificationsSetting() }
    
    private func toggleDarkMode() { interactor.toggleDarkModeSetting() }
    
    private func toggleHaptics() { interactor.toggleHapticsSetting() }
}

// MARK: - ViewToPresenterProtocol
extension AppSettingsPresenter {
    var appSettingCount: Int { appSettings.count }
    
    func viewLoaded() { interactor.requestNotificationsSettings() }
    
    func appSetting(at indexPath: IndexPath) -> AppSetting { appSettings[indexPath.row] }
    
    func didSwitchValue(at indexPath: IndexPath) { appSettings[indexPath.row].toggle() }
}

// MARK: - InteractorToPresenterProtocol
extension AppSettingsPresenter {
    func presentErrorMessage() {
        view.presentErrorMessage()
    }
}

// MARK: - RouterToPresenterProtocol
extension AppSettingsPresenter {}
