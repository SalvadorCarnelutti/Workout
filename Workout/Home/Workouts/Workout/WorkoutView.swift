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
    func denyTap(at indexPath: IndexPath)
}

final class WorkoutView: UIView {
    private var isAnimating = false
    // MARK: - Properties
    weak var presenter: WorkoutViewToPresenterProtocol?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.register(WorkoutSettingTableViewCell.self)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func shakeCell(_ cell: UITableViewCell) {
        guard !isAnimating else {
            return
        }
        
        isAnimating = true
        
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.values = [-5.0, 5.0, -2.0, 2.0, 0.0]
        animation.duration = 0.3
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            feedbackGenerator.impactOccurred()
            self.isAnimating = false
        }
        
        cell.layer.add(animation, forKey: "shakeAnimation")
        
        CATransaction.commit()
    }
}

// MARK: - PresenterToViewProtocol
extension WorkoutView: WorkoutPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .systemBackground
        setupConstraints()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func denyTap(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) { shakeCell(cell) }
    }
}

extension WorkoutView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.workoutSettingsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter,
              let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutSettingTableViewCell.identifier, for: indexPath) as? WorkoutSettingTableViewCell else {
            WorkoutSettingTableViewCell.assertCellFailure()
            return UITableViewCell()
            
        }
        
        cell.configure(with: presenter.workoutSetting(at: indexPath))
        return cell
    }
}

extension WorkoutView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
}
