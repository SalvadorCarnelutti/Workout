//
//  
//  ExercisesView.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import UIKit
import CoreData

protocol ExercisesPresenterToViewProtocol: UIView, NSFetchedResultsControllerDelegate {
    var presenter: ExercisesViewToPresenterProtocol? { get set }
    func loadView()
    func updateSections()
}

final class ExercisesView: UIView {
    // MARK: - Properties
    weak var presenter: ExercisesViewToPresenterProtocol?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
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
extension ExercisesView: ExercisesPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
    
    func updateSections() {
        let sectionToReload = 0
        let indexSet: IndexSet = [sectionToReload]

        tableView.reloadSections(indexSet, with: .automatic)
    }
}

extension ExercisesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.exercisesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell,
        let presenter = presenter else {
            ExerciseTableViewCell.assertCellFailure()
            return UITableViewCell()
        }
        
        let exercise = presenter.exerciseAt(indexPath: indexPath)
        cell.configure(with: exercise)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}
}

extension ExercisesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        
        if editingStyle == .delete {
            let exercise = presenter.exerciseAt(indexPath: indexPath)
            exercise.managedObjectContext?.delete(exercise)
        }
    }
}

extension ExercisesView: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let presenter = presenter else {
            return []
        }
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = presenter.exerciseAt(indexPath: indexPath)
        return [dragItem]
    }
}

extension ExercisesView: NSFetchedResultsControllerDelegate {    
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
                cell.configure(with: presenter.exerciseAt(indexPath: indexPath))
            }
        default:
            return
        }
    }
}
