//
//  WorkoutSettingsViewController.swift
//  Workout
//
//  Created by Salvador on 7/28/23.
//

import UIKit

protocol WorkoutSettingsPresenterToViewProtocol: AnyObject {
    func reloadData()
    func denyTap(at indexPath: IndexPath)
}

final class WorkoutSettingsViewController: BaseTableViewController {
    private var isAnimating = false
    let presenter: WorkoutSettingsViewToPresenterProtocol
    
    init(presenter: WorkoutSettingsViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     - workoutName can change
     - exercisesCount and sessionsCount can change
     - session enabled status can change
     */
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        presenter.emptySessionsIfNeeded()
        presenter.updateSessionsSettingEnabledStatus()
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func handleNotificationTap(for workout: Workout) { presenter.handleNotificationTap(for: workout) }
    
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
        CATransaction.setCompletionBlock { [presenter] in
            if presenter.areHapticsEnabled { feedbackGenerator.impactOccurred() }
            self.isAnimating = false
        }
        
        cell.layer.add(animation, forKey: "shakeAnimation")
        
        CATransaction.commit()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = String(localized: "Workout")
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(WorkoutSettingTableViewCell.self)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
    }
}

// MARK: - PresenterToViewProtocol
extension WorkoutSettingsViewController: WorkoutSettingsPresenterToViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func denyTap(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) { shakeCell(cell) }
    }
}

extension WorkoutSettingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.workoutSettingsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutSettingTableViewCell.identifier, for: indexPath) as? WorkoutSettingTableViewCell else {
            WorkoutSettingTableViewCell.assertCellFailure()
            return UITableViewCell()
            
        }
        
        cell.configure(with: presenter.workoutSetting(at: indexPath))
        return cell
    }
}

extension WorkoutSettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
}
