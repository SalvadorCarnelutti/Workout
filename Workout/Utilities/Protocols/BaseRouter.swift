//
//  BaseRouter.swift
//  Workout
//
//  Created by Salvador on 7/22/23.
//

import UIKit

protocol BaseRouterProtocol {
    var navigation: (() -> UIViewController?) { get set }
}

class BaseRouter: BaseRouterProtocol {
    lazy var navigation: (() -> UIViewController?) = { nil }
    
    var presentedViewController: UIViewController? { navigation() }
    var navigationController: UINavigationController? { navigation()?.navigationController }
}
