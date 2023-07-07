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
    
    private struct Constraints {
        static let ActivityIndicatorSize: CGFloat = 80
    }
    
    private lazy var activityIndicator: ActivityIndicator = {
        let activityIndicator = ActivityIndicator()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        loadPersistentContainer()
    }
    
    private func setupTabs(managedObjectContext: NSManagedObjectContext) {
        let firstTab = WorkoutsConfigurator.resolveFor(managedObjectContext: managedObjectContext)
        let secondTab = ScheduledSessionsConfigurator.resolveFor(managedObjectContext: managedObjectContext)
        
        viewControllers = [
            getNavigationController(for: firstTab, title: "Workouts", image: .list),
            getNavigationController(for: secondTab, title: "Scheduled", image: .calendar),
        ]
    }
    
    private func loadPersistentContainer() {
        showLoader()
        coreDataManager.loadPersistentContainer { [weak self] result in
            guard let self = self else { return }
            
            self.hideLoader()
            switch result {
            case .success:
                self.setupTabs(managedObjectContext: self.coreDataManager.managedObjectContext)
            case .failure(let error):
                print("Unable to Add Persistent Store")
                print("\(error), \(error.localizedDescription)")
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
