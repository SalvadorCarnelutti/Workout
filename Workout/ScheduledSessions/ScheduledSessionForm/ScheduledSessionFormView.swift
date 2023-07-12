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

protocol ScheduledSessionFormPresenterToViewProtocol: UIView, NSFetchedResultsControllerDelegate {
    var presenter: ScheduledSessionFormViewToPresenterProtocol? { get set }
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate { get }
    var sessionFormOutput: SessionFormOutput? { get }
    func loadView()
    func fillSessionFields(with sessionFormInput: SessionFormInput)
}

final class ScheduledSessionFormView: UIView {
    // MARK: - Properties
    weak var presenter: ScheduledSessionFormViewToPresenterProtocol?
    
    private lazy var tableView: ExercisesTableView = {
        let tableView = ExercisesTableView()
        addSubview(tableView)
        tableView.setDelegate(exerciseTableViewDelegate: self)
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
extension ScheduledSessionFormView: ScheduledSessionFormPresenterToViewProtocol {
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate { tableView }
    
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
        presenter?.viewLoaded()
    }
    
    func fillSessionFields(with sessionFormInput: SessionFormInput) {
        if let selectedDayOfWeek = DayOfWeek(rawValue: sessionFormInput.day) {
            datePicker.date = sessionFormInput.startsAt
            daySelectionView.selectDayOfWeek(selectedDayOfWeek)
        }
    }
}

extension ScheduledSessionFormView: UITableViewDataSource {
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

extension ScheduledSessionFormView: UITableViewDelegate {
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

extension ScheduledSessionFormView: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let presenter = presenter else {
            return []
        }
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = presenter.exercise(at: indexPath)
        return [dragItem]
    }
}

extension ScheduledSessionFormView: ExerciseTableViewDelegate {
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
