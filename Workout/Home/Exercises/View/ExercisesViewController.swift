//
//  ExercisesViewController.swift
//  Workout
//
//  Created by Salvador on 7/26/23.
//

import UIKit
import CoreData

protocol ExercisesPresenterToViewProtocol: NSFetchedResultsControllerDelegate {
    var presenter: ExercisesViewToPresenterProtocol! { get }
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate { get }
}

final class ExercisesViewController: BaseTableViewController, NSFetchedResultsControllerDelegate {
    let presenter: ExercisesViewToPresenterProtocol!
    
    init(presenter: ExercisesViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewLoaded()
        updateContentUnavailableConfiguration()
    }
    
    private func configureTableView() {
        tableView.register(ExerciseTableViewCell.self)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = false
        tableView.dragDelegate = self
    }
    
    @objc private func addExerciseTapped() {
        presenter.addExerciseTapped()
    }

    private func setupNavigationBar() {
        navigationItem.title = presenter.workoutName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            image: UIImage.add,
                                                            target: self,
                                                            action: #selector(addExerciseTapped))
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        configureTableView()
    }
    
    private func showEmptyState() {
        configureEmptyContentUnavailableConfiguration(image: .ellipsis,
                                                      text: String(localized: "No exercises at the moment"),
                                                      secondaryText: String(localized: "Start adding on the top-right"))
    }
    
    private func updateContentUnavailableConfiguration() {
        UIView.animate(withDuration: 0.25, animations: {
            self.presenter.exercisesCount == 0 ? self.showEmptyState() : self.clearContentUnavailableConfiguration()
        })
    }
}

// MARK: - PresenterToViewProtocol
extension ExercisesViewController: ExercisesPresenterToViewProtocol {
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate { self }
}

// MARK: - UITableViewDelegate
extension ExercisesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.exercisesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell else {
            ExerciseTableViewCell.assertCellFailure()
            return UITableViewCell()
        }
        
        let exercise = presenter.exercise(at: indexPath)
        cell.configure(with: exercise)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        
        presenter.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: - UITableViewDataSource
extension ExercisesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { presenter.deleteRow(at: indexPath) }
    }
}

// MARK: - UITableViewDragDelegate
extension ExercisesViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let presenter = presenter else {
            return []
        }
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = presenter.exercise(at: indexPath)
        return [dragItem]
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ExercisesViewController {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    /*
    The fetched results controller reports changes to its section before changes to the fetch result objects.
    Changes are reported with the following heuristics:
    It’s assumed that all objects that come after the affected object are also moved, but these moves are not reported.
    */
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch (type) {
        // On add and remove operations, only the added/removed object is reported.
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
                updateContentUnavailableConfiguration()
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                presenter.didDeleteRow(at: indexPath)
                updateContentUnavailableConfiguration()
            }
        // An update is reported when an object’s state changes, but the changed attributes aren’t part of the sort keys.
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ExerciseTableViewCell {
                cell.configure(with: presenter.exercise(at: indexPath))
            }
        // A move is reported when the changed attribute on the object is one of the sort descriptors used in the fetch request.
        // An update of the object is assumed in this case, but no separate update message is sent to the delegate.
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            
            // Moving might also require to update other cells in the tableView
            tableView.reloadData()
        default:
            return
        }
    }
}
