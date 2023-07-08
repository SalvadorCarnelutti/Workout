//
//  
//  AppSettingsView.swift
//  Workout
//
//  Created by Salvador on 7/7/23.
//
//
import UIKit

protocol AppSettingsPresenterToViewProtocol: UIView {
    var presenter: AppSettingsViewToPresenterProtocol? { get set }
    func loadView()
}

final class AppSettingsView: UIView {
    // MARK: - Properties
    weak var presenter: AppSettingsViewToPresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        addSubview(tableView)
        tableView.dataSource = self
        tableView.register(AppSettingTableViewCell.self)
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: - PresenterToViewProtocol
extension AppSettingsView: AppSettingsPresenterToViewProtocol {
    func loadView() {
        backgroundColor = .systemBackground
        setupConstraints()
        presenter?.viewLoaded()
    }
}

extension AppSettingsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.appSettingCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppSettingTableViewCell.identifier, for: indexPath) as? AppSettingTableViewCell,
        let presenter = presenter else {
            AppSettingTableViewCell.assertCellFailure()
            return UITableViewCell()
        }
        
        let appSetting = presenter.appSetting(at: indexPath)
        cell.configure(with: appSetting)
        cell.switchValueChangedCallback = {
            presenter.didSwitchValue(at: indexPath)
        }
        
        return cell
    }
}
