//
//  
//  WorkoutView.swift
//  Workout
//
//  Created by Salvador on 6/20/23.
//
//
import UIKit

protocol WorkoutPresenterToViewProtocol: UIView {
    var presenter: WorkoutViewToPresenterProtocol? { get set }
    func loadView()
    func reloadData()
}

final class WorkoutView: UIView {
    // MARK: - Properties
    weak var presenter: WorkoutViewToPresenterProtocol?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WorkoutSectionTableViewHeader.self)
        tableView.register(UITableViewCell.self)
        tableView.backgroundColor = .systemBackground
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
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
extension WorkoutView: WorkoutPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension WorkoutView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.rowCount(at: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        
        var content = UIListContentConfiguration.cell()
        content.text = presenter.workoutRow(at: indexPath.section)
        
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.sectionsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let presenter = presenter,
              let header = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: WorkoutSectionTableViewHeader.identifier) as? WorkoutSectionTableViewHeader else {
            WorkoutSectionTableViewHeader.assertHeaderFailure()
            return UITableViewHeaderFooterView()
        }
        
        header.configure(with: presenter.workoutSection(at: section))
        presenter.setupWorkoutSectionDelegate(for: header)
        return header
    }
}

extension WorkoutView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
