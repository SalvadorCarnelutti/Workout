//
//  
//  ScheduledSessionFormPresenter.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
//

import UIKit

protocol ScheduledSessionFormViewToPresenterProtocol: UIViewController {
    func viewLoaded()
}

protocol ScheduledSessionFormRouterToPresenterProtocol: UIViewController {}

final class ScheduledSessionFormPresenter: BaseViewController {
    var viewScheduledSessionForm: ScheduledSessionFormPresenterToViewProtocol!
    var interactor: ScheduledSessionFormPresenterToInteractorProtocol!
    var router: ScheduledSessionFormPresenterToRouterProtocol!
    
    override func loadView() {
        super.loadView()
        view = viewScheduledSessionForm
        viewScheduledSessionForm.loadView()
    }
}

// MARK: - ViewToPresenterProtocol
extension ScheduledSessionFormPresenter: ScheduledSessionFormViewToPresenterProtocol {
    func viewLoaded() {}
}

// MARK: - RouterToPresenterProtocol
extension ScheduledSessionFormPresenter: ScheduledSessionFormRouterToPresenterProtocol {}
