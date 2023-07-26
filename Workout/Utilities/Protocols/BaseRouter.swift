//
//  BaseRouter.swift
//  Workout
//
//  Created by Salvador on 7/22/23.
//

import UIKit

protocol BaseRouterProtocol {
    var navigation: (() -> UINavigationController?) { get set }
}

class BaseRouter: BaseRouterProtocol {
    lazy var navigation: (() -> UINavigationController?) = { nil }
    
    var navigationController: UINavigationController? { navigation() }
}
