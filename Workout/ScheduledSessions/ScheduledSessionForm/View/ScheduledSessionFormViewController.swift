//
//  ScheduledSessionFormViewController.swift
//  Workout
//
//  Created by Salvador on 7/28/23.
//

import UIKit
import CoreData

protocol ScheduledSessionFormPresenterToViewProtocol: AnyObject {
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate { get }
    func fillSessionFields(with sessionFormInput: SessionFormInput)
}

final class ScheduledSessionFormViewController: BaseViewController {
    let presenter: ScheduledSessionFormViewToPresenterProtocol
    let scheduledSessionFormView = ScheduledSessionFormView()
    
    init(presenter: ScheduledSessionFormViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let sessionFormOutput = scheduledSessionFormView.sessionFormOutput {
            presenter.editSessionCompletionAction(for: sessionFormOutput)
        }
    }
    
    override func loadView() {
        super.loadView()
        view = scheduledSessionFormView
        setupViews()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = presenter.workoutName
    }
    
    private func setupViews() {
        setupNavigationBar()
        scheduledSessionFormView.delegate = self
        scheduledSessionFormView.loadView()
    }
}

// MARK: - PresenterToViewProtocol
extension ScheduledSessionFormViewController: ScheduledSessionFormPresenterToViewProtocol {
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate { scheduledSessionFormView }
    
    func fillSessionFields(with sessionFormInput: SessionFormInput) { scheduledSessionFormView.fillSessionFields(with: sessionFormInput) }
}

extension ScheduledSessionFormViewController: ScheduledSessionFormViewDelegate {
    var exercisesCount: Int { presenter.exercisesCount }
    
    func viewLoaded() { presenter.viewLoaded() }
    
    func exercise(at indexPath: IndexPath) -> Exercise { presenter.exercise(at: indexPath) }
    
    func deleteRow(at indexPath: IndexPath) { presenter.deleteRow(at: indexPath) }
    
    func didSelectRow(at indexPath: IndexPath) { presenter.didSelectRow(at: indexPath) }
    
    func didDeleteRow(at indexPath: IndexPath) { presenter.didDeleteRow(at: indexPath) }
    
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { presenter.moveRow(at: sourceIndexPath, to: destinationIndexPath) }    
}
