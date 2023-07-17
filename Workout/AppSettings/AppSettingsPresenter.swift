//
//  
//  AppSettingsPresenter.swift
//  Workout
//
//  Created by Salvador on 7/7/23.
//
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

protocol AppSettingsViewToPresenterProtocol: UIViewController {
    var appSettingCount: Int { get }
    func viewLoaded()
    func appSetting(at indexPath: IndexPath) -> AppSetting
    func didSwitchValue(at indexPath: IndexPath)
}

protocol AppSettingsRouterToPresenterProtocol: UIViewController {}

final class AppSettingsPresenter: BaseViewController {
    var viewAppSettings: AppSettingsPresenterToViewProtocol!
    var interactor: AppSettingsPresenterToInteractorProtocol!
    var router: AppSettingsPresenterToRouterProtocol!
    
    private lazy var appSettings = [notificationsAppSetting,
                                    darkModeAppSetting,
                                    hapticsAppSetting]
    
    override func loadView() {
        super.loadView()
        view = viewAppSettings
        viewAppSettings.loadView()
        setupNavigationBar()
    }
    
    private var notificationsAppSetting: AppSetting {
        let areNotificationsEnabled = interactor.areNotificationsEnabled
        
        return AppSetting(isOn: areNotificationsEnabled,
                          toggleImageModel: ToggleImageModel(asDefault: areNotificationsEnabled,
                                                             defaultImage: .notificationsOff,
                                                             defaultBackgroundColor: .systemRed,
                                                             alternateImage: .notificationsOn,
                                                             alternateBackgroundColor: .systemRed),
                          name: "Notifications",
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
                          name: "Dark Mode",
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
                          name: "Haptics",
                          toggleAction: toggleHaptics)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Settings"
    }
    
    private func toggleNotificationsSetting() {
        interactor.toggleNotificationsSetting()
    }
    
    private func toggleDarkMode() {
        interactor.toggleDarkModeSetting()
    }
    
    private func toggleHaptics() {
        interactor.toggleHapticsSetting()
    }
}

// MARK: - ViewToPresenterProtocol
extension AppSettingsPresenter: AppSettingsViewToPresenterProtocol {
    var appSettingCount: Int { appSettings.count }
    
    func viewLoaded() { interactor.requestNotificationsSettings() }
    
    func appSetting(at indexPath: IndexPath) -> AppSetting { appSettings[indexPath.row] }
    
    func didSwitchValue(at indexPath: IndexPath) { appSettings[indexPath.row].toggle() }
}

// MARK: - RouterToPresenterProtocol
extension AppSettingsPresenter: AppSettingsRouterToPresenterProtocol {}
