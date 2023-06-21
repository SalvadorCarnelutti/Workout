//
//  
//  SessionsView.swift
//  Workout
//
//  Created by Salvador on 6/21/23.
//
//
import UIKit
import CoreData

protocol SessionsPresenterToViewProtocol: UIView, NSFetchedResultsControllerDelegate {
    var presenter: SessionsViewToPresenterProtocol? { get set }
    func loadView()
}

final class SessionsView: UIView {
    // MARK: - Properties
    weak var presenter: SessionsViewToPresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExerciseTableViewCell.self)
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
extension SessionsView: SessionsPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
}

extension SessionsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.sessionsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell,
        let presenter = presenter else {
            ExerciseTableViewCell.assertCellFailure()
            return UITableViewCell()
        }
        
        let session = presenter.sessionAt(indexPath: indexPath)
//        cell.configure(with: session)
        return cell
    }
}

extension SessionsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        
        if editingStyle == .delete {
            presenter.deleteRowAt(indexPath: indexPath)
        }
    }
}

extension SessionsView: NSFetchedResultsControllerDelegate {
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
                presenter.didDeleteRowAt(indexPath)
            }
        // An update is reported when an object’s state changes, but the changed attributes aren’t part of the sort keys.
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ExerciseTableViewCell {
//                cell.configure(with: presenter.sessionAt(indexPath: indexPath))
            }
        default:
            return
        }
    }
}
