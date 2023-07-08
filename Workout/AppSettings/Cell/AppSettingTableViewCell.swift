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
    var isOnImage: UIImage?
    var isOffImage: UIImage?

    private lazy var settingImageView: UIImageView = {
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5.0
        return imageView
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
            make.height.width.equalTo(40)
        }
        settingNameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.left.equalTo(settingImageView.snp.right).offset(8)
        }
        
        settingSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(settingNameLabel)
            make.right.equalToSuperview().offset(-10)
            make.left.greaterThanOrEqualTo(settingNameLabel.snp.right).offset(10)
        }
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        switchValueChangedCallback?()
        toggleImage()
    }
    
    private func toggleImage() {
        let animationDuration: TimeInterval = 0.3
        UIView.animate(withDuration: animationDuration, animations: {
            self.settingImageView.alpha = 0
        }) { _ in
            self.settingImageView.image = self.settingSwitch.isOn ? self.isOnImage : self.isOffImage
            UIView.animate(withDuration: animationDuration) {
                self.settingImageView.alpha = 1
            }
        }
    }
    
    func configure(with appSetting: AppSetting) {
        settingImageView.image = appSetting.displayImage
        settingNameLabel.text = appSetting.name
        settingSwitch.isOn = appSetting.isOn
        
        isOnImage = appSetting.isOnImage
        isOffImage = appSetting.isOffImage
    }
}
