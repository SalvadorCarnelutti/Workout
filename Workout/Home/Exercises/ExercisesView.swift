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

protocol ExercisesPresenterToViewProtocol: UIView, NSFetchedResultsControllerDelegate, ExerciseTableViewDelegate {
    var presenter: ExercisesViewToPresenterProtocol? { get set }
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate { get }
    func loadView()
}

final class ExercisesView: UIView {
    // MARK: - Properties
    weak var presenter: ExercisesViewToPresenterProtocol?
    
    lazy var tableView: ExercisesTableView = {
        let tableView = ExercisesTableView()
        addSubview(tableView)
        tableView.setDelegate(exerciseTableViewDelegate: self)
        return tableView
    }()
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

// MARK: - PresenterToViewProtocol
extension ExercisesView: ExercisesPresenterToViewProtocol {
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate { tableView }
    
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
        
        let exercise = presenter.exercise(at: indexPath)
        cell.configure(with: exercise)
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let presenter = presenter, sourceIndexPath != destinationIndexPath else { return }
        
        presenter.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}

extension ExercisesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        
        if editingStyle == .delete {
            presenter.deleteRow(at: indexPath)
        }
    }
}

extension ExercisesView: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let presenter = presenter else {
            return []
        }
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = presenter.exercise(at: indexPath)
        return [dragItem]
    }
}

extension ExercisesView: ExerciseTableViewDelegate {
    func exercise(at indexPath: IndexPath) -> Exercise {
        (presenter?.exercise(at: indexPath))!
    }
    
    func didDeleteRow(at indexPath: IndexPath) {
        presenter?.didDeleteRow(at: indexPath)
    }
    
    func didChangeExerciseCount() {
        presenter?.didChangeExerciseCount()
    }
}
