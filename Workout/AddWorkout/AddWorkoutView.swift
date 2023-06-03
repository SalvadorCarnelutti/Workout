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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 8),
            tableView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
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
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
