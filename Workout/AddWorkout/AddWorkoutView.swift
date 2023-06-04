//
//  
//  AddWorkoutView.swift
//  Workout
//
//  Created by Salvador on 6/3/23.
//
//
import UIKit

protocol AddWorkoutPresenterToViewProtocol: UIView {
    var presenter: AddWorkoutViewToPresenterProtocol? { get set }
    func loadView()
}

final class AddWorkoutView: UIView {
    // MARK: - Properties
    weak var presenter: AddWorkoutViewToPresenterProtocol?
    
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
extension AddWorkoutView: AddWorkoutPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .white
        setupConstraints()
        presenter?.viewLoaded()
    }
}

extension AddWorkoutView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell,
        let presenter = presenter else {
            ExerciseTableViewCell.assertCellFailure()
            return UITableViewCell()
        }
        
        let ex = Exercise(context: presenter.managedObjectContext)
        ex.name = "Dumbbell curls"
        ex.duration = 20
        ex.sets = 4
        ex.reps = 16
        cell.configure(with: ex)
        return cell
    }
}
