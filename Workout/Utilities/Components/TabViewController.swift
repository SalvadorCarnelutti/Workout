//
//  TabViewController.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import UIKit
import CoreData

final class TabBarViewController: UITabBarController, BaseViewProtocol {
    let coreDataManager = CoreDataManager.shared
    let appearanceManager = AppearanceManager.shared
    
    private struct Constraints {
        static let ActivityIndicatorSize: CGFloat = 80
    }
    
    private lazy var activityIndicator: ActivityIndicator = {
        let activityIndicator = ActivityIndicator()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        appearanceManager.updateAppearanceMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        loadPersistentContainer()
    }
    
    private func setupTabs(managedObjectContext: NSManagedObjectContext) {
        let workoutsTab = WorkoutsConfigurator.resolveFor(managedObjectContext: managedObjectContext)
        let scheduledSessionsTab = ScheduledSessionsConfigurator.resolveFor(managedObjectContext: managedObjectContext)
        let appSettingsTab = AppSettingsConfigurator.resolveFor(managedObjectContext: managedObjectContext)
        
        viewControllers = [
            getNavigationController(for: workoutsTab, title: "Workouts", image: .list),
            getNavigationController(for: scheduledSessionsTab, title: "Scheduled", image: .calendar),
            getNavigationController(for: appSettingsTab, title: "Settings", image: .settings)
        ]
    }
    
    func selectWorkoutsTab() {
        selectedIndex = 0
    }
    
    func selectScheduledSessionsTab() {
        selectedIndex = 1
    }
    
    func selectAppSettingsTab() {
        selectedIndex = 2
    }
    
    func handleLocalNotificationTap(for identifier: String) {
        guard let tabControllers = viewControllers,
              let navigationController = tabControllers.first as? UINavigationController,
              let workoutsPresenter = navigationController.viewControllers.first as? WorkoutsPresenter else { return }
        
        selectWorkoutsTab()
        navigationController.popToViewController(workoutsPresenter, animated: false)
        workoutsPresenter.handleNotificationTap(for: identifier)
    }
    
    private func loadPersistentContainer() {
        showLoader()
        coreDataManager.loadPersistentContainer { [weak self] result in
            guard let self = self else { return }
            
            self.hideLoader()
            switch result {
            case .success:
                self.setupTabs(managedObjectContext: self.coreDataManager.managedObjectContext)
            case .failure:
                presentErrorMessage()
            }
        }
    }
    
    func showLoader() {
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        view.sendSubviewToBack(activityIndicator)
        activityIndicator.stopAnimating()
    }
    
    func presentOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func presentErrorMessage() {
        presentOKAlert(title: "Unexpected error occured", message: "There was an error loading your information")
    }
    
    private func setupViews() {
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        activityIndicator.centerInSuperview()
        activityIndicator.constraintSizeWithEqualSides(Constraints.ActivityIndicatorSize)
    }
}

extension TabBarViewController {
    func getNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}

fileprivate extension UIView {
    func pinToSuperview() {
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
    
    func centerInSuperview() {
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    func constraintSizeWithEqualSides(_ size: CGFloat) {
        constraintSize(CGSize(width: size, height: size))
    }
    
    func constraintSize(_ size: CGSize) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size.height),
            widthAnchor.constraint(equalToConstant: size.width)
        ])
    }
}
