//
//  
//  ScheduledSessionsView.swift
//  Workout
//
//  Created by Salvador on 6/25/23.
//
//
import UIKit
import CoreData

protocol ScheduledSessionsPresenterToViewProtocol: UIView, NSFetchedResultsControllerDelegate {
    var presenter: ScheduledSessionsViewToPresenterProtocol? { get set }
    var selectedDay: Int { get }
    func loadView()
    func reloadData()
}

final class ScheduledSessionsView: UIView {
    // MARK: - Properties
    weak var presenter: ScheduledSessionsViewToPresenterProtocol?
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: DayOfWeek.allCases.map { $0.shortDescription })
        addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SessionTableViewCell.self)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        updateTableViewDataSource(for: sender.selectedSegmentIndex)
    }
    
    private func updateTableViewDataSource(for selectedIndex: Int) {
        presenter?.didSelectDay(at: selectedIndex)
    }
    
    private func selectCurrentDay() {
        segmentedControl.selectedSegmentIndex = Date.weekday
    }
    
    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

// MARK: - PresenterToViewProtocol
extension ScheduledSessionsView: ScheduledSessionsPresenterToViewProtocol {
    var selectedDay: Int {
        segmentedControl.selectedSegmentIndex
    }
    
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        selectCurrentDay()
        presenter?.viewLoaded()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension ScheduledSessionsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.sessionsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.identifier, for: indexPath) as? SessionTableViewCell,
        let presenter = presenter else {
            SessionTableViewCell.assertCellFailure()
            return UITableViewCell()
        }
        
        let session = presenter.session(at: indexPath)
        cell.configure(with: session)
        return cell
    }
}

extension ScheduledSessionsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter, editingStyle == .delete else { return }
        
        presenter.deleteRow(at: indexPath)
    }
}

extension ScheduledSessionsView: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        // TODO: Display something for when sessions count is 0
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? SessionTableViewCell {
                cell.configure(with: presenter.session(at: indexPath))
            }
        default:
            return
        }
    }
}
