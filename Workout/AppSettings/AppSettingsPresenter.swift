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
            toggleAction(isOn)
        }
    }
    var isOffImage: UIImage
    var isOnImage: UIImage
    var name: String
    var toggleAction: (Bool) -> ()
    
    var displayImage: UIImage { isOn ? isOnImage : isOffImage }
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
    
    private lazy var appSettings = [AppSetting(isOn: true,
                                               isOffImage: .notificationsOff,
                                               isOnImage: .notificationsOn,
                                               name: "Notifications",
                                               toggleAction: toggleNotificationsSetting),
                                    AppSetting(isOn: false,
                                               isOffImage: .darkModeOn,
                                               isOnImage: .darkModeOff,
                                               name: "Dark Mode",
                                               toggleAction: toggleDarkMode)]
    
    override func loadView() {
        super.loadView()
        view = viewAppSettings
        viewAppSettings.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Settings"
    }
    
    private func toggleNotificationsSetting(_ isOn: Bool) {
        isOn ? requestNotificationsSettings() : interactor.removeAllPendingNotificationRequests()
    }
    
    private func toggleDarkMode(_ isOn: Bool) {
        
    }
}

// MARK: - ViewToPresenterProtocol
extension AppSettingsPresenter: AppSettingsViewToPresenterProtocol {
    var appSettingCount: Int { appSettings.count }
    
    func viewLoaded() {}
    
    func appSetting(at indexPath: IndexPath) -> AppSetting {
        appSettings[indexPath.row]
    }
    
    func didSwitchValue(at indexPath: IndexPath) {
        appSettings[indexPath.row].toggle()
    }
}

// MARK: - RouterToPresenterProtocol
extension AppSettingsPresenter: AppSettingsRouterToPresenterProtocol {}

extension AppSettingsPresenter {
    private func requestNotificationsSettings() {
        // Request Notification Settings
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }

                    // Schedule Local Notification
                    self.interactor.scheduleLocalNotifications()
                })
            case .authorized:
                // Schedule Local Notification
                self.interactor.scheduleLocalNotifications()
            default:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }

            completionHandler(success)
        }
    }
}
