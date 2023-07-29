//
//  AppSettingsViewController.swift
//  Workout
//
//  Created by Salvador on 7/28/23.
//

import UIKit

protocol AppSettingsPresenterToViewProtocol: AnyObject {
    func presentErrorMessage()
}

final class AppSettingsViewController: BaseTableViewController {
    // MARK: - Properties
    let presenter: AppSettingsViewToPresenterProtocol
    
    init(presenter: AppSettingsViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = String(localized: "Settings")
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(AppSettingTableViewCell.self)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = false
    }
}

// MARK: - PresenterToViewProtocol
extension AppSettingsViewController: AppSettingsPresenterToViewProtocol {}

// MARK: - UITableViewDataSource
extension AppSettingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.appSettingCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppSettingTableViewCell.identifier, for: indexPath) as? AppSettingTableViewCell else {
            AppSettingTableViewCell.assertCellFailure()
            return UITableViewCell()
        }
        
        let appSetting = presenter.appSetting(at: indexPath)
        cell.configure(with: appSetting)
        cell.switchValueChangedCallback = { [weak presenter] in
            presenter?.didSwitchValue(at: indexPath)
        }
        
        return cell
    }
}
