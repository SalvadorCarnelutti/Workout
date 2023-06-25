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
    func updateSections()
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
        tableView.backgroundColor = .systemBackground
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
    }
    
    func updateSections() {
        let sectionToReload = 0
        let indexSet: IndexSet = [sectionToReload]

        tableView.reloadSections(indexSet, with: .automatic)
    }
}

extension WorkoutView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
        
        header.configure(with: presenter.workoutSectionAt(section: section))
        presenter.setupWorkoutSectionDelegate(for: header)
        return header
    }
}

extension WorkoutView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
