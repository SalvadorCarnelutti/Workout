//
//  TabViewController.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabs()
    }
    
    func setupTabs() {
        viewControllers = [
            getNavigationController(for: Self.firstTab, title: "Workouts", image: .strokedCheckmark),
        ]
    }
}

extension TabBarViewController {
    func getNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
    
    static var firstTab: UIViewController {
        WorkoutsConfigurator.resolve()
    }
}

