//
//  BaseRouter.swift
//  Workout
//
//  Created by Salvador on 7/22/23.
//

import UIKit

protocol BaseRouterProtocol {
    var navigation: (() -> UINavigationController?) { get set }
    var presentation: (() -> UIViewController?) { get set }
}

class BaseRouter: BaseRouterProtocol {
    lazy var navigation: (() -> UINavigationController?) = { nil }
    lazy var presentation: (() -> UIViewController?) = { nil }
    
    var presentingViewController: UIViewController? { presentation() }
    var navigationController: UINavigationController? { navigation() }
}
