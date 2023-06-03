//
//  
//  TestingPresenter.swift
//  Workout
//
//  Created by Salvador on 5/31/23.
//
//

import UIKit

protocol TestingViewToPresenterProtocol: UIViewController {
    func viewLoaded()
}

final class TestingPresenter: UIViewController {
    var viewTesting: TestingPresenterToViewProtocol!
    var interactor: TestingPresenterToInteractorProtocol!
    var router: TestingPresenterToRouterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTesting.loadView()
    }
    
    override func loadView() {
        super.loadView()
        view = viewTesting
    }
}

// MARK: - ViewToPresenterProtocol
extension TestingPresenter: TestingViewToPresenterProtocol {
    func viewLoaded() {}
}
