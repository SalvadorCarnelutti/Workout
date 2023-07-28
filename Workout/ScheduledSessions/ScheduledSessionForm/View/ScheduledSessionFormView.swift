//
//  
//  ScheduledSessionFormView.swift
//  Workout
//
//  Created by Salvador on 6/27/23.
//
//
import UIKit
import CoreData

protocol ScheduledSessionFormViewDelegate: AnyObject {
    var exercisesCount: Int { get }
    func viewLoaded()
    func exercise(at indexPath: IndexPath) -> Exercise
    func deleteRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func didDeleteRow(at indexPath: IndexPath)
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

final class ScheduledSessionFormView: UIView {
    // MARK: - Properties
    weak var delegate: ScheduledSessionFormViewDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        addSubview(tableView)
        tableView.register(ExerciseTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        return tableView
    }()
    
    private lazy var daySelectionView: DaySelectionView = {
        let daySelectionView = DaySelectionView(style: .compact)
        addSubview(daySelectionView)
        return daySelectionView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        addSubview(datePicker)
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        datePicker.timeZone = TimeZone.current
        datePicker.minuteInterval = 5
        return datePicker
    }()
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
        }
        
        daySelectionView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(daySelectionView.snp.bottom).offset(5)
            make.right.equalTo(daySelectionView.snp.right)
            make.height.equalTo(50)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
}

// MARK: - PresenterToViewProtocol
extension ScheduledSessionFormView {
    var sessionFormOutput: SessionFormOutput? {
        guard let selectedDay = daySelectionView.weekday,
              let startsAt = datePicker.date.formatAs("h:mm a") else { return nil }
        
        let formOutput = SessionFormOutput(day: selectedDay,
                                           startsAt: startsAt)
        
        return formOutput
    }
    
    func loadView() {
        backgroundColor = .systemBackground
        setupConstraints()
        delegate?.viewLoaded()
    }
    
    func fillSessionFields(with sessionFormInput: SessionFormInput) {
        if let selectedDayOfWeek = DayOfWeek(rawValue: sessionFormInput.day) {
            datePicker.date = sessionFormInput.startsAt
            daySelectionView.selectDayOfWeek(selectedDayOfWeek)
        }
    }
}

// MARK: - UITableViewDataSource
extension ScheduledSessionFormView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.exercisesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell,
        let delegate = delegate else {
            ExerciseTableViewCell.assertCellFailure()
            return UITableViewCell()
        }
        
        let exercise = delegate.exercise(at: indexPath)
        cell.configure(with: exercise)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        
        delegate?.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: - UITableViewDelegate
extension ScheduledSessionFormView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { delegate?.deleteRow(at: indexPath) }
    }
}

// MARK: - UITableViewDragDelegate
extension ScheduledSessionFormView: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let delegate = delegate else {
            return []
        }
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = delegate.exercise(at: indexPath)
        return [dragItem]
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ScheduledSessionFormView: NSFetchedResultsControllerDelegate {
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
        guard let delegate = delegate else { return }
        
        switch (type) {
        // On add and remove operations, only the added/removed object is reported.
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                delegate.didDeleteRow(at: indexPath)
            }
        // An update is reported when an object’s state changes, but the changed attributes aren’t part of the sort keys.
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ExerciseTableViewCell {
                cell.configure(with: delegate.exercise(at: indexPath))
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
