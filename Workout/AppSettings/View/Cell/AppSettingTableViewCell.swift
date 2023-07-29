//
//  AppSettingTableViewCell.swift
//  Workout
//
//  Created by Salvador on 7/7/23.
//

import UIKit

typealias SwitchValueChangedCallback = () -> ()

final class AppSettingTableViewCell: UITableViewCell {
    var switchValueChangedCallback: SwitchValueChangedCallback?

    private lazy var settingImageView: ToggleImageView = {
        let toggleImageView = ToggleImageView()
        contentView.addSubview(toggleImageView)
        return toggleImageView
    }()
    
    private lazy var settingNameLabel: MultilineLabel = {
        let label = MultilineLabel()
        contentView.addSubview(label)
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var settingSwitch: UISwitch = {
        let switchView = UISwitch()
        contentView.addSubview(switchView)
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return switchView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        settingImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalTo(settingNameLabel)
            make.height.width.equalTo(38)
        }
        settingNameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.left.equalTo(settingImageView.snp.right).offset(18)
        }
        
        settingSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(settingNameLabel)
            make.right.equalToSuperview().offset(-10)
            make.left.greaterThanOrEqualTo(settingNameLabel.snp.right).offset(10)
        }
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        switchValueChangedCallback?()
        settingImageView.toggle()
    }
    
    func configure(with appSetting: AppSetting) {
        settingNameLabel.text = appSetting.name
        settingSwitch.isOn = appSetting.isOn
        
        settingImageView.configure(with: ToggleImageModel(asDefault: !appSetting.isOn,
                                                          defaultImage: appSetting.toggleImageModel.defaultImage,
                                                          defaultBackgroundColor: appSetting.toggleImageModel.defaultBackgroundColor,
                                                          alternateImage: appSetting.toggleImageModel.alternateImage,
                                                          alternateBackgroundColor: appSetting.toggleImageModel.alternateBackgroundColor))
    }
}
