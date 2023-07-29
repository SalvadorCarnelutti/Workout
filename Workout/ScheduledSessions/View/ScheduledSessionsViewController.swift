//
//  ScheduledSessionsViewController.swift
//  Workout
//
//  Created by Salvador on 7/28/23.
//

import UIKit
import CoreData

protocol ScheduledSessionsPresenterToViewProtocol: AnyObject {
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate { get }
    var selectedWeekday: Int { get }
    var selectedWeekdayString: String { get }
    func loadView()
    func reloadData()
}

final class ScheduledSessionsViewController: BaseViewController {
    let presenter: ScheduledSessionsViewToPresenterProtocol
    let scheduledSessionsView = ScheduledSessionsView()
    
    init(presenter: ScheduledSessionsViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Because NSFetchedResultsController only tracks changes to its non relationship attributes, we must consider Workout's exercises count and time duration updates
    // This could be really inefficient if we had to update large volumes of data in a table view, but for this app's usage it's fine
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        scheduledSessionsView.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        view = scheduledSessionsView
        setupViews()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = String(localized: "Scheduled Sessions")
    }
    
    private func setupViews() {
        setupNavigationBar()
        scheduledSessionsView.delegate = self
        scheduledSessionsView.loadView()
    }
    
    private func showEmptyState() {
        configureEmptyContentUnavailableConfiguration(image: .ellipsis,
                                                      text: String(localized: "No sessions set for \(selectedWeekdayString)"),
                                                      secondaryText: String(localized: "Start adding from the Workouts tab"))
    }
    
    private func updateContentUnavailableConfiguration() {
        UIView.animate(withDuration: 0.25, animations: {
            self.presenter.sessionsCount == 0 ? self.showEmptyState() : self.clearContentUnavailableConfiguration()
        })
    }
}

// MARK: - PresenterToViewProtocol
extension ScheduledSessionsViewController: ScheduledSessionsPresenterToViewProtocol {
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate { scheduledSessionsView }
    
    var selectedWeekday: Int { scheduledSessionsView.selectedWeekday }
    
    var selectedWeekdayString: String { scheduledSessionsView.selectedWeekdayString }
    
    func reloadData() {
        scheduledSessionsView.reloadData()
        updateContentUnavailableConfiguration()
    }
}

// MARK: - ScheduledSessionsViewDelegate
extension ScheduledSessionsViewController: ScheduledSessionsViewDelegate {
    var sessionsCount: Int { presenter.sessionsCount }
    
    func viewLoaded() {
        presenter.viewLoaded()
        updateContentUnavailableConfiguration()
    }
    
    // TODO: Change for appropiate wording
    func didSelectDay(at: Int) { presenter.didSelect(day: at) }
    
    func session(at indexPath: IndexPath) -> Session { presenter.session(at: indexPath) }
    
    func deleteRow(at indexPath: IndexPath) { presenter.deleteRow(at: indexPath) }
    
    func didSelectRow(at indexPath: IndexPath) { presenter.didSelectRow(at: indexPath) }
    
    func didChangeSessionCount() { updateContentUnavailableConfiguration() }
}
