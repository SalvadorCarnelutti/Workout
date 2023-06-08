//
//  
//  WorkoutView.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import UIKit
import CoreData

protocol WorkoutPresenterToViewProtocol: UIView, NSFetchedResultsControllerDelegate {
    var presenter: WorkoutViewToPresenterProtocol? { get set }
    func loadView()
}

final class WorkoutView: UIView {
    // MARK: - Properties
    weak var presenter: WorkoutViewToPresenterProtocol?
    
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
extension WorkoutView: WorkoutPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
}

extension WorkoutView: UITableViewDataSource {
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

extension WorkoutView: UITableViewDelegate {
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

extension WorkoutView: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let presenter = presenter else {
            return []
        }
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = presenter.exerciseAt(indexPath: indexPath)
        return [dragItem]
    }
}

extension WorkoutView: NSFetchedResultsControllerDelegate {    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        // TODO: Display something for when exercises count is 0
//        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let presenter = presenter else { return }
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ExerciseTableViewCell {
                cell.configure(with: presenter.exerciseAt(indexPath: indexPath))
            }
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
