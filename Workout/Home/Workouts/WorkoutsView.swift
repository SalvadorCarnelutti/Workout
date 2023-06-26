//
//  
//  WorkoutsView.swift
//  Workout
//
//  Created by Salvador on 6/2/23.
//
//
import UIKit
import CoreData

protocol WorkoutsPresenterToViewProtocol: UIView, NSFetchedResultsControllerDelegate {
    var presenter: WorkoutsViewToPresenterProtocol? { get set }
    func loadView()
}

final class WorkoutsView: UIView {
    // MARK: - Properties
    weak var presenter: WorkoutsViewToPresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WorkoutTableViewCell.self)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

// MARK: - PresenterToViewProtocol
extension WorkoutsView: WorkoutsPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
}

extension WorkoutsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.workoutsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as? WorkoutTableViewCell,
        let presenter = presenter else {
            WorkoutTableViewCell.assertCellFailure()
            return UITableViewCell()
        }
        
        let exercise = presenter.workout(at: indexPath)
        cell.configure(with: exercise)
        return cell
    }
}

extension WorkoutsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter, editingStyle == .delete else { return }
        
        presenter.deleteRow(at: indexPath)
    }
}

extension WorkoutsView: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        // TODO: Display something for when exercises count is 0
//        updateView()
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
        guard let presenter = presenter else { return }
        
        switch (type) {
        // On add and remove operations, only the added/removed object is reported.
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        // An update is reported when an object’s state changes, but the changed attributes aren’t part of the sort keys.
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? WorkoutTableViewCell {
                cell.configure(with: presenter.workout(at: indexPath))
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
        @unknown default:
            return
        }
    }
}
