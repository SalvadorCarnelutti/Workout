//
//  
//  ScheduledSessionsPresenter.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//
//

import UIKit

protocol ScheduledSessionsViewToPresenterProtocol: UIViewController {
    func viewLoaded()
}

protocol ScheduledSessionsRouterToPresenterProtocol: UIViewController {}

final class ScheduledSessionsPresenter: BaseViewController {
    var viewScheduledSessions: ScheduledSessionsPresenterToViewProtocol!
    var interactor: ScheduledSessionsPresenterToInteractorProtocol!
    var router: ScheduledSessionsPresenterToRouterProtocol!
    
    override func loadView() {
        super.loadView()
        view = viewScheduledSessions
        viewScheduledSessions.loadView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Scheduled Sessions"
    }
}

// MARK: - ViewToPresenterProtocol
extension ScheduledSessionsPresenter: ScheduledSessionsViewToPresenterProtocol {
    func viewLoaded() {}
}

// MARK: - RouterToPresenterProtocol
extension ScheduledSessionsPresenter: ScheduledSessionsRouterToPresenterProtocol {}
