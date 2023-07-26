//
//  ExercisesTableView.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//

import UIKit
import CoreData

protocol ExerciseTableViewDelegate: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {
    func exercise(at indexPath: IndexPath) -> Exercise
    func didDeleteRow(at indexPath: IndexPath)
    func didChangeExerciseCount()
}

final class ExercisesTableView: UITableView {
    weak var exerciseTableViewDelegate: ExerciseTableViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        register(ExerciseTableViewCell.self)
        estimatedRowHeight = UITableView.automaticDimension
    }
    
    func setDelegate(exerciseTableViewDelegate: ExerciseTableViewDelegate) {
        self.exerciseTableViewDelegate = exerciseTableViewDelegate
        delegate = exerciseTableViewDelegate
        dataSource = exerciseTableViewDelegate
        dragDelegate = exerciseTableViewDelegate
    }
}

extension ExercisesTableView: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        endUpdates()
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
        guard let exerciseTableViewDelegate = exerciseTableViewDelegate else { return }
        
        switch (type) {
        // On add and remove operations, only the added/removed object is reported.
        case .insert:
            if let indexPath = newIndexPath {
                insertRows(at: [indexPath], with: .fade)
                exerciseTableViewDelegate.didChangeExerciseCount()
            }
        case .delete:
            if let indexPath = indexPath {
                deleteRows(at: [indexPath], with: .fade)
                exerciseTableViewDelegate.didDeleteRow(at: indexPath)
                exerciseTableViewDelegate.didChangeExerciseCount()
            }
        // An update is reported when an object’s state changes, but the changed attributes aren’t part of the sort keys.
        case .update:
            if let indexPath = indexPath, let cell = cellForRow(at: indexPath) as? ExerciseTableViewCell {
                cell.configure(with: exerciseTableViewDelegate.exercise(at: indexPath))
            }
        // A move is reported when the changed attribute on the object is one of the sort descriptors used in the fetch request.
        // An update of the object is assumed in this case, but no separate update message is sent to the delegate.
        case .move:
            if let indexPath = indexPath {
                deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                insertRows(at: [newIndexPath], with: .fade)
            }
            
            // Moving might also require to update other cells in the tableView
            reloadData()
        default:
            return
        }
    }
}
